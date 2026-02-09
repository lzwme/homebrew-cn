class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghfast.top/https://github.com/joeyates/imap-backup/archive/refs/tags/v16.4.2.tar.gz"
  sha256 "62274d8d8e060aee4cebaf57e3f34df388c6791c7e9e83393c0d59c47c3e4ee5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d8d9fb1b4608b8f8eb9ad38336c2c7c7bfce1c4b64e1d93a3f9061fed16f42e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8d9fb1b4608b8f8eb9ad38336c2c7c7bfce1c4b64e1d93a3f9061fed16f42e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8d9fb1b4608b8f8eb9ad38336c2c7c7bfce1c4b64e1d93a3f9061fed16f42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "56ab7aa774c1cc776299527351a852cf91a01f3f4c1d2290cc8ba2902e3b882a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55ce93eaea642923fde642aab2b9e8655a14d22606ac187cec1e82572d6cd1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd66687299ce0bfc99c6dd25e44df29aa7be04c708793d5d25237df8fc580e6"
  end

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