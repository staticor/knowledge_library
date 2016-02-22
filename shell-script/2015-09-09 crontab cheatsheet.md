
这是一篇我简单整理的关于crontab的blog.

---
date: 2015-09-09 20:29
status: public
tags: 'linux, shell, coding'
title: '2015-09-09 crontab cheatsheet'
---

**crontab** is a list used to drive the **cron daemon**. 

![](http://i5.tietuku.com/202eaf54921ea42b.jpg)

Each user has its own crontab, those files in /var/spool/cron/crontabs. So, first should know is

crontab ===  Cron Table. 

# Cron 
**Cron** is very useful to execute scheduled tasks in shell.  It searches crontab files, loaded into memory. 

> crontab files

Examing all crontabs, checking each command to see if it should run in next **minute**.  Whenever crontab is changed, crontab updates the modtime of the spool directory.

Jobs that run at a particular time in period. Usually it is written:


`30 12 * * * /bin/sh ~/test/sh 2> ~/crontab.log`

# Crontab

Blank lines and leading spaces (and tabs) are ignored. 
Comments used # (hash-sign), like Python, are also ignored.

Each valid line in crontab should be a correct cron command, or an environment setting. 

> environment setting
name = value
example: PATH= "$HOME/bin:$PATH" 


Some envrionment variables are set up automatically:
* SHELL: /bin/sh
* LOGNAME, HOME: /etc/passwd line of crontab's owner.
* MAILTO: if it is defined(not empty), mail is sent to user so named.

HOME, SHELL, PATH may  be overridden by settings. LOGNAME is the user that the job is running from. 


# Format: 5 Time Field + command

valid cront format consists of different field to specify which time to execute.

`minute,  hour,  day of month,  month, day of week`
```
Minute: 0-59

Hour: 0-23

Day of Month: 1-31

Month: 1-12 or Jan-Dec

Day of Week: 0-6, or Sun-Sat

```
===

* \* (asterisk) stands for "first-last",  meaning an-all-range.

* finite list also commonly used, a set of numbers (or ranges) separated by commas: "1,2,4,10", "0-4,8-12"
* step values: used in time sequences. following a range with "/" specifies skips of the number's value through the range.
For example, "0-23/2" can be used in the hours field to specify command execution every other hour 
==> "0,2,4,6,8,10,12,14,16,18,20,22"


> string         meaning
------         -------
@reboot        Run once, at startup.
@yearly        Run once a year, "0 0 1 1 *".
@annually      (same as @yearly)
@monthly       Run once a month, "0 0 1 * *".
@weekly        Run once a week, "0 0 * * 0".
@daily         Run once a day, "0 0 * * *".
@midnight      (same as @daily)
@hourly        Run once an hour, "0 * * * *".




# my tip

crontab uses different context from your local path. you'd better use absolute path (shell, script, or text files, etc), to avoid simple bugs.



# reference
[reference](http://www.pantz.org/software/cron/croninfo.html)

