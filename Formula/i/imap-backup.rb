class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https:github.comjoeyatesimap-backup"
  url "https:github.comjoeyatesimap-backuparchiverefstagsv14.5.2.tar.gz"
  sha256 "5aadb511661c4e58a7e6e335c17f848a08d04637f2483523d7f38c805088494c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0bf188a5745b6bdc4cb2607207df4a3a71f95185d3f756a2a5677bbc25078d5"
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