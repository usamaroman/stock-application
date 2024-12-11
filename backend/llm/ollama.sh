#!/usr/bin/env bash

ollama serve & \
ollama list 

ollama create stockmodel -f /Modefile
