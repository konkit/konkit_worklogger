# KonkitWorklogger - log your work automatically

What's the problem with logging work? You have to remember about it.
How many times have you forgotten to write the start or the end time of your work?

This tool measures how long your computer is turned on. 
Therefore all you need to care about is to turn your computer off when you finish your day.

Under the hood, it writes a new line to a file each minute (scheduled by cron).
Then, it gathers all those "minutes" to calculate your work time.
Because of that, it works even if you have to pause the work for some time - you just need to turn the computer off.
