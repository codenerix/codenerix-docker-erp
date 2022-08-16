#!/bin/bash

echo "-----------Apply migration--------- "
./manage.py migrate
./manage.py touch

echo "-----------Check General User--------- "
cat <<EOF | python manage.py shell
from django.contrib.auth import get_user_model

User = get_user_model()  # get the currently active user model,

User.objects.filter(username='$CODENERIX_USER').exists() or \
User.objects.create_superuser('$CODENERIX_USER', '$CODENERIX_EMAIL', '$CODENERIX_PASSWORD') and \
print("Added user '$CODENERIX_USER'!")
EOF

echo "-----------Run Django Server--------- "
./manage.py runserver 0.0.0.0:5000

# echo "-----------Run gunicorn--------- "
# basic gunicorn command, binding to port 5000
# gunicorn -b :5000 erp.wsgi:application

# specify the number of workers with a positive integer. Generally, 4*(num cores) defaults to  1
# gunicorn -b :5000 --workers INT erp.wsgi:application

# Outputs the access log to a file named logfile. Use - to output to stdout
# gunicorn -b :5000 --access-logfile logfile erp.wsgi:application

# specify log level default is info. Options for LEVEL: debug, info, warning, error, critical
# gunicorn -b :5000 --log-level LEVEL erp.wsgi:application
