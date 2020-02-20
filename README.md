# Jenkins Job Monitor

This bash script monitors the amount of time, that is necessary for Jenkins jobs to finish. If this amount of time falls into the threshold defined in `MAX_MINUTE`, it will send an alert to the defined Slack channel. The script is executed as a cron job in every 15 minutes. 

All jenkins jobs are running in a temporary script in the /tmp folder with the name `jenkins.*\.sh`. Running `ps -fU jenkins -o pid,etime,command` and grepping for `/tmp/jenkins` will allow you to identify all jobs run by Jenkins. This way we also won't pick up the jenkins process either, that probably runs for a long period of time.

After that we need to identify all jobs that are running longer than a certain period of time. If we run `ps` with the option `-o etime`, it will show us the total amount of time a process needed to run so far. You can test this expression in the terminal using `watch -d 'ps -fU jenkins -o pid,etime,command | grep "/tmp/jenkins"'`. If you figure out the maximum amount of time a process should be allowed to run, you can define it in the `MAX_MINUTE` variable using extended regex. 

We save the results of the first grep (searching for `/tmp/jenkins`) to a variable called `RUNNING_JOBS`. This will allow us to grep again and identify all the processes that run at least as long as the amount of time we defined in `RUNNING_JOBS`. The usage of extended regex will allow us to define the maximum amount of minutes `[3-5][0-9]:` or any value that is higher than that `:.*:` (hours). Notice the colons placed next to the regex values, the position of these mark that we are either talking about minutes (30:00) or hours (01:00:00).

If grep finds a process that's running too long, it will send a message using `curl` to the slack channel, that I connected via a webhook. This incoming webhook needs to be generated on slack (https://api.slack.com/messaging/webhooks). I won't send any other information, since if an employee logs in to the Jenkins frontend, he/she will see which job is running for a long time and got potentially 'stuck'. In my opinion it wouldn't make much sense to include pid and command in the message, since the scripts are randomly generated for every job.

