# Protected

This page is protected by HTTP basic authentication.

To protect this page the `example/scripts/post` modifies the nginx configuration to require basic authentication.
The `example/.htpasswd` file was created by running `htpasswd -c .htpassword user` and then entering `password` (twice) when prompted.
