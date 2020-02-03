#!/usr/bin/env bash

for file in *.fq
do
  mv $file ${file//ggal/chicken}
done