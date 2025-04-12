#! /bin/bash
export EVENTSIM_CONFIG_FILE='configs/ad-config.json'
export EVENTSIM_NUM_USERS=800000
export EVENTSIM_GROWTH_RATE=5
export EVENTSIM_START_TIME="`date +"%Y-%m-%dT%H:%M:%S"`"
export EVENTSIM_END_TIME="`date -d "+30 days" +"%Y-%m-%dT%H:%M:%S"`"
export EVENTSIM_RANDOM_SEED=42

