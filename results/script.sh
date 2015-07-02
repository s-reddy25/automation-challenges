#!/bin/bash

command=`facter -p widget`

dynamic_value="widget_type ${command}"

sed -i "s/widget_type\sX/${dynamic_value}/g" template.file
