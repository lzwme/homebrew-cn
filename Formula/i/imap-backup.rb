class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghproxy.com/https://github.com/joeyates/imap-backup/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "2460f1f7f7761b95810bb9743264d5ccd37df808904fd255e14b21f7a4403955"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4583efadb544ad280053281742cc266484398b9b724238de49c0d7d9dd59b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4583efadb544ad280053281742cc266484398b9b724238de49c0d7d9dd59b56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4583efadb544ad280053281742cc266484398b9b724238de49c0d7d9dd59b56"
    sha256 cellar: :any_skip_relocation, ventura:        "c4583efadb544ad280053281742cc266484398b9b724238de49c0d7d9dd59b56"
    sha256 cellar: :any_skip_relocation, monterey:       "c4583efadb544ad280053281742cc266484398b9b724238de49c0d7d9dd59b56"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4583efadb544ad280053281742cc266484398b9b724238de49c0d7d9dd59b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6157b149528085bccb7021448973425aa10618cc6a5104f1b6a8ca83dff2c2b7"
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