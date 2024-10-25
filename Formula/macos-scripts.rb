class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https:github.comnicerloopmacos-scripts"
  url "https:github.comnicerloopmacos-scriptsarchiverefstagsv1.9.4.tar.gz"
  sha256 "036670857fa69970b64cfbe85ab3ca09d466b8d308de9b521ffa5ed313ac30f9"

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