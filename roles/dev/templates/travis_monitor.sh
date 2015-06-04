#!/bin/bash

clear
travis monitor {% for repo in source.github %}-r {{ repo.org }}/{{ repo.repo }} {% endfor %}
