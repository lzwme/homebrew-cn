class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghproxy.com/https://github.com/joeyates/imap-backup/archive/refs/tags/v14.3.0.tar.gz"
  sha256 "dbce303addf4d14970d783d3c8c3b00b63825d5095f3fc2792735bffb245e27b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "559a618d7389ddfda663ca45e9475dded51e34018650c86c8f7a45739ec8495c"
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