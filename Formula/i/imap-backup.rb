class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghfast.top/https://github.com/joeyates/imap-backup/archive/refs/tags/v16.4.0.tar.gz"
  sha256 "020cd3f0bf5b826602b7987353a6daf74af21f11f941e0adaa0b037cd2443a47"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "151c557535230bdcaa38b6243d79dc0c1d23ad242fe2085f2ae6c3425e2f99c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151c557535230bdcaa38b6243d79dc0c1d23ad242fe2085f2ae6c3425e2f99c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151c557535230bdcaa38b6243d79dc0c1d23ad242fe2085f2ae6c3425e2f99c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f69912f1484c51653b57de07a6b2cbd3bf17074f2e94f78c5a9560f9d541e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9f3aaf814e55d0b8173e0b619c6b03439f074b4022a2813761d9ca7de6a0107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6f98d54322375e638d7d8c4b4ce9151942f60b3e7a13bc3505bdc5786e53c0"
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