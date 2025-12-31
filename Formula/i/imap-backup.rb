class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghfast.top/https://github.com/joeyates/imap-backup/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "e854a7482f4dff1f1b666156880d75bd7c35ca596b48c4a261e17c73feefed7d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7198b56dde4b7d5695235a606144c8377735decd27e9b07715720f7749567b3"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output("#{bin}/imap-backup setup", "3\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end