class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https:github.comnicerloopmacos-scripts"
  url "https:github.comnicerloopmacos-scriptsarchiverefstagsv1.9.3.tar.gz"
  sha256 "d58263a70ce9d25fec89ee7f13c7d20605329e3360b348f75c97633bf3be3257"

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
  end
end