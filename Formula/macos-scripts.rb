class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https://github.com/nicerloop/macos-scripts"
  url "https://ghproxy.com/https://github.com/nicerloop/macos-scripts/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "ac78ae564a84f7309ec90a32cb9380c3d7dc2496e7f358f6e45faa84fe5c95c7"

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