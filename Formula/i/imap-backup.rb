class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghproxy.com/https://github.com/joeyates/imap-backup/archive/refs/tags/v14.4.4.tar.gz"
  sha256 "a2262c1fad026bef6f9f1ce8e83ce2ca9f70bdffd2ec1037f496e9bd1d7ec96d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0bb410fd3924e9912c72a49423b501ff5e4508e8d3b7cbc92418023df4d46f49"
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
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "3\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end