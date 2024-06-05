class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https:github.comjoeyatesimap-backup"
  url "https:github.comjoeyatesimap-backuparchiverefstagsv15.0.1.tar.gz"
  sha256 "393b54e782bf470f0142f95886a6cdee211c7d7d1d556f16e5abd75b2bade208"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5b068cbba63ec1eded5c02f5908cf1743f1ec53553fbb3a0ff9c8f5c2325d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5b068cbba63ec1eded5c02f5908cf1743f1ec53553fbb3a0ff9c8f5c2325d1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b068cbba63ec1eded5c02f5908cf1743f1ec53553fbb3a0ff9c8f5c2325d1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5b068cbba63ec1eded5c02f5908cf1743f1ec53553fbb3a0ff9c8f5c2325d1c"
    sha256 cellar: :any_skip_relocation, ventura:        "b5b068cbba63ec1eded5c02f5908cf1743f1ec53553fbb3a0ff9c8f5c2325d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "b5b068cbba63ec1eded5c02f5908cf1743f1ec53553fbb3a0ff9c8f5c2325d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0f4dbbdca45b3e9ecfc096ece5c5e43e84acfefc427c74106a3b85db4e36397"
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