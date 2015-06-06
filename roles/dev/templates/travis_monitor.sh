#!/bin/bash

clear
unset DBUS_SESSION_BUS_ADDRESS
travis monitor --builds --notify {% for repo in source.github %}-r {{ repo.org }}/{{ repo.repo }} {% endfor %}
