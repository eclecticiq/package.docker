Docker container for creating packages

- uses `fpm` to build packages
- based on alpine
- supports deb/rpm
- package signing using `dpkg-sig` and `rpmsign`
