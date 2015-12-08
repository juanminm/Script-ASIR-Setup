# Changelog
## Unreleased
## 0.1.3 - 2015-12-08
### Added
- Add README.md file.
- Add CHANGELOG.md file.

### Changed
- Change form by using Zenity instead of CLI input.

## 0.1.2 - 2015-12-04
### Added
- Add line `sudo apt-get update` before `sudo apt-get install [...]` line.

### Fixed
- Fix relative path used for test to absolute path.
- Fix missing `-i` option for `sed`.
## 0.1.1 - 2015-12-03
### Added
- Add `cat <<LDAPEOF` so that it generates the LDAP setup script.
- Add escaping inside the `cat`.

### Changed
- Change LDAP hostname example to a generic one ('Sldap-pc00').
- Change some tabulation into whitespace.
- Add whitespace between "browsable =" and "no".

### Fixed
- Renamed 'getip' to 'get_ip' in `$LDAPSRVIP` modification.
## 0.1.0 - 2015-12-02
### Added
- Add function `get_ip()` to combine Network IP variables with host IP
  variables.
- Complete form for future server setups (DNS, Apache, MySQL...).

## 0.0.5 - 2015-12-02
### Changed
- Change `$LDAPSRVIP` request to receive the last octect.
- Lower indent at line 215.

### Fixed
- Add escaping to double quotes near `$SMBDOMAIN`.
- Fix `cat` not working with `sudo` by adding `bash -c`.
- Change incorrect IPs to variables.

## 0.0.4 - 2015-12-02
### Added
- Add last commands for LDAP setup ending at NFS configuration.

### Changed
- Add indent to line-splitted `sed` command

### Fixed
- Fix `sed` command to smbldap_bind.conf by adding `sudo`
- Fix `cat` not working with `sudo` by adding `bash -c`.
## 0.0.3 - 2015-12-02
### Added
- Add more LDAP variables on the form.
- Add commands from finishing smbldap-tools to LAM installation.

### Changed
- Add global variables for masterLDAP.

### Fixed
- Change 'People' to 'Users' to comply with smbtools.
- Add `-i` option to `sed` at line 181.

## 0.0.2 - 2015-12-01
### Added
- Add first part of LDAP form.
- Store local SID to a variable.
- Replace smbldap.conf contents using `sed`.

### Changed
- Remove the use of escaping with double quotes.
- Replace specific information with variables.

## 0.0.1 - 2015-12-01
### Added
- Add first part of LDAP server setup.
- Make script template for the different servers.
