class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://ghfast.top/https://github.com/joeyates/imap-backup/archive/refs/tags/v16.5.0.tar.gz"
  sha256 "f926446d970fd8572da3a8f6b9b8f99cea3ea03d4f73f59ef4fd782c4c006fcf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0ecbbe76960f8b5ddc5413a88fb03b311aa0267dbe120cf53ef5d2c6362753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0ecbbe76960f8b5ddc5413a88fb03b311aa0267dbe120cf53ef5d2c6362753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0ecbbe76960f8b5ddc5413a88fb03b311aa0267dbe120cf53ef5d2c6362753"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a4f203fc40333ada0e7c9ab1fb0c1c5e8aba24fa83cacc586c3d501b55e7b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da490cd25a21fba6c2675d119b036476835f32055307622115bb81092a547ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eafc3ae2777423bc7c1d5470db700c5965e83fb87a52fd6664bfa26995d01d7"
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