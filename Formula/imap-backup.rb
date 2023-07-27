class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghproxy.com/https://github.com/joeyates/imap-backup/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "c07867542bfdef48b5d6e1438440fc94f4bacbc0b4fac45539ce905382081650"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf7d930b1f308e4c2fdac0026f7367bc0eef4c09922f982baf2116783d08e80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf7d930b1f308e4c2fdac0026f7367bc0eef4c09922f982baf2116783d08e80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bf7d930b1f308e4c2fdac0026f7367bc0eef4c09922f982baf2116783d08e80"
    sha256 cellar: :any_skip_relocation, ventura:        "4bf7d930b1f308e4c2fdac0026f7367bc0eef4c09922f982baf2116783d08e80"
    sha256 cellar: :any_skip_relocation, monterey:       "4bf7d930b1f308e4c2fdac0026f7367bc0eef4c09922f982baf2116783d08e80"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bf7d930b1f308e4c2fdac0026f7367bc0eef4c09922f982baf2116783d08e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d21a733c88c49db2c08cae9203a7d450bd649127c879e83e2ba44c2d0fb21ddf"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "2\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end