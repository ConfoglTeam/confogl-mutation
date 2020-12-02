#!/bin/bash

NUT_TESTS=$(find tests -type f -name "*.test.nut") squirrel tests/main.nut
