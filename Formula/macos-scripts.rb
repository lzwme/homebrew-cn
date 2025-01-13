class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https:github.comnicerloopmacos-scripts"
  url "https:github.comnicerloopmacos-scriptsarchiverefstagsv1.9.5.tar.gz"
  sha256 "3a735ec00b808b0429a939065ebff1d0b306a2fad009d583d2575d40cd672fcc"

  def install
    bin.install "brew-bundle-leaves"
    bin.install "brew-bundle-patch-install-receipts"
    bin.install "launchpad-reset"
    bin.install "launchpad-sort"
    bin.install "login-picture"
    bin.install "mas-versions.sh" => "mas-versions"
    bin.install "rsync-backup"
    bin.install "smb-volume-mount"
    bin.install "sudo-pam-configure"
    bin.install "vnc-connect"
    bin.install "volume-icon"
    bin.install "webloc-to-url"
    bin.install "xcode-command-line-tools-reinstall"
    bin.install "xcode-uninstall"
    bin.install "brewup.sh" => "brewup"
    bin.install "brewbump.sh" => "brewbump"
    bin.install "brewfetch.sh" => "brewfetch"
    bin.install "brewstyleaudit.sh" => "brewstyleaudit"
    bin.install "docker-host.sh" => "docker-host"
  end
end