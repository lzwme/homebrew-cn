class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https:github.comjoeyatesimap-backup"
  url "https:github.comjoeyatesimap-backuparchiverefstagsv14.5.1.tar.gz"
  sha256 "2273e0a8212652b8571170865d8a3abadfcacbdde65b62f08eec4affa58d7f62"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fe9de766ebc1653bf758fa4dc8808fe1f82eba759ec492933acc04675efc1fd"
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