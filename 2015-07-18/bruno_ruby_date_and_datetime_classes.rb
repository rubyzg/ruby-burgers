# Look into ruby's messy Date and Time libraries

# Problem {{{
# 3 classes for handling date and time ???
# Time, Date and DateTime    - WAT?

# Time is ruby core class
# require 'date' loads Date and DateTime classes (std library)

require 'date'

Time.now
DateTime.now

# Time class already has date???

# }}}
# Tasks {{{

# Get familiar with each of the classes.
# Figure why each one is used for.

# }}}
# Time class {{{

# adds facilities for:
# 1. creating time instances (local or UTC time)
# 2. getting each of the time's attributes
# 3. converting UTC <-> system local time

# 1. creating time {{{
Time.now
Time.new(2020, 1, 1, 12, 30, 45)

# converting unix timestamp to time
Time.at(123434)

Time.utc(2020, 1, 1, 12, 30, 45)
Time.local(2020, 1, 1)
#  }}}
# 2. getting each of the time's attributes {{{
t = Time.now
t.to_a

# following are just convenience methods for the above
t.year
t.month
t.day

t.hour
t.sec

t.nsec
t.zone

# }}}
# 3. converting UTC <-> system time {{{
t.getutc

t.getutc.getlocal
# }}}
# 4. other {{{
# get seconds
t.to_i
t.saturday?

# week day number [0..6] 0 == Sunday
t.wday

# number of seconds offset from utc
t.utc_offset

t.utc?

# very powerful formatting with cryptic codes
t.strftime("%b")
# }}}

# lacking:
# - time zones
# - time + 1.day
# - other formats rfc3339 etc (maybe)

# }}}
# DateTime class {{{
#
# support for extra calendars and formats:
# - julian day - used in astronomy and history
# - commercial calendar (year, week number, week day)
# - ordinal day (year, year day)

# support for parsing and outputing extra formats
# - rfc3339
# - iso8601
# - rfc2822
# - httpdate
# - xmlschema

# 1. creating/parsing various formats
# 2. outputing/converting to various formats

# 1. creating/parsing various formats {{{
Date.today
DateTime.now
DateTime.new(2020, 1, 1)
DateTime.parse("2020-3-12")

DateTime.commercial(2020, 50, 1)

DateTime.jd(2_444_555)

DateTime.httpdate("Sat, 03 Feb 2001 04:05:06 GMT")
# }}}
# 2. outputing/converting to various formats {{{
dt = DateTime.now

# regular methods (the same as Time class)
dt.year
dt.month
dt.day

dt.hour
dt.minute
dt.sec

dt.zone

# julian day
dt.jd

# modified julian day
dt.mjd

# commercial calendar methods
dt.cweek
dt.cwday

# rfc
dt.rfc3339
# }}}

# }}}
# Conclusion {{{

# ruby Time and Date are complex
# use Time
# use Date if there's a need for other calendars and conversions
#
# no proper support for time zones

# }}}
# vim: fdm=marker
