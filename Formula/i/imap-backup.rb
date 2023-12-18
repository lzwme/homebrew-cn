class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https:github.comjoeyatesimap-backup"
  url "https:github.comjoeyatesimap-backuparchiverefstagsv14.4.5.tar.gz"
  sha256 "35d8f2a18f071263671813130f51dcf21423eea347646cfd70ecd4a9343a224a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee29239a34be2e7a6d6e365dd741cea4bb143ac691d73f423c8adc0bfed21f4d"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin"name
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin"imap-backup setup", "3\n")
    assert_match version.to_s, shell_output("#{bin}imap-backup version")
  end
end