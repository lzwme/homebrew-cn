class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.72.1.tgz"
  sha256 "c6ba2099fd2c1f6453bd2c0841277921f8793e8d5c9d0ae376a804df6b0d4412"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8465de5e44cbf87a13181c58d6b04d16d8a7b6a501f47bfc70c44265a5004fab"
    sha256 cellar: :any,                 arm64_sequoia: "5007b555ad472706d2d039b17258d777ac20a6f72002e71233c6d8f849fae461"
    sha256 cellar: :any,                 arm64_sonoma:  "5007b555ad472706d2d039b17258d777ac20a6f72002e71233c6d8f849fae461"
    sha256 cellar: :any,                 sonoma:        "79fa9101cb10cf6a3af13b7d546855b0cb3cbe4a5acadc1fa858f9c6a1cc7081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b39569f907973a431facca0bb4725e5c922e677e88e65661cb4deaaa30c8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "028a6160c7e4bd69c9795e64b5b4b455464abc82d519481ddf73420a1a3adb54"
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