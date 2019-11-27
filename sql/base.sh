#!/bin/bash

psql -U postgres -f /tmp/sql/00_init_db.sql
psql hram -U monkey_user -f /tmp/sql/01_init.sql
psql hram -U monkey_user -f /tmp/sql/02_fill_values.sql
psql hram -U monkey_user -f /tmp/sql/03_view.sql
psql hram -U monkey_user -f /tmp/sql/04_fill_test_values.sql