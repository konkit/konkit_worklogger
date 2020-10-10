# KonkitWorklogger - log your work automatically

What's the problem with logging work? You have to remember about it.
How many times have you forgotten to write the start or the end time of your work?

This tool measures how long your computer is turned on. 
Therefore all you need to care about is to turn your computer off when you finish your day.

Under the hood, it writes a new line to a file each minute (scheduled by cron).
Then, it gathers all those "minutes" to calculate your work time.
Because of that, it works even if you have to pause the work for some time - you just need to turn the computer off.


# Installation

### Step 0 - setup the correct ruby version with RVM

```
rvm use ...
```

### Step 1 - install the gem

```
gem install konkit_worklogger
```


### Step 2 - create the config file with a folder with your entries
```
echo "path: \"$HOME/.konkit_worklogger/timeentries\"" > $HOME/.konkit_worklogger/config.yml
```

### Step 3 - setup the Cron job
First, we have to run the `rvm cron setup` command to fill our cron file with needed variables.

```
rvm cron setup 
```

Then, we have to edit the cron file and add the worklogger command

```
crontab -e
```

Add the following line there:


```
* * * * * $MY_RUBY_HOME/bin/ruby $GEM_HOME/bin/worklogger increment
```


# Usage 
To display the help screen, run:
```
worklogger
```

To display today's entries, run:
```
worklogger today
```

To display the entries for the whole month with carry from previous months, run: 
```
worklogger month
```
