class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.68.0.tgz"
  sha256 "997ea5cbc895f54b7c3f4b8041a15641f031c122d3e347a8c1a08067f644181d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "530065534cdfc282ea4e1e166a860f1c25255a0ed567b57496dad5f675f4e15b"
    sha256 cellar: :any,                 arm64_sequoia: "51bb99b01f95914c3ba0f3c2955181103045a7c8f50e79d931422ed1e1d7ca88"
    sha256 cellar: :any,                 arm64_sonoma:  "51bb99b01f95914c3ba0f3c2955181103045a7c8f50e79d931422ed1e1d7ca88"
    sha256 cellar: :any,                 sonoma:        "50b96ab21fd1534acd2a2abc13f1b7d339757eba7c896423ce8c6e691d078ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac5ea1944b5385fb14116c57275499250cdbbc979ef14d973ee321d3a8ce0499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd03bcbb8310ca487b391d6812469748c01a22fe19b0de028725dd6b90eae1f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end