class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.69.0.tgz"
  sha256 "213bed5d187e692f1ccd19afe233380d676d26fac5971d7e7fc06266937945b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cb92420d605e7a0a09268605050272b523481b3952c6e057e3c386fe832efba"
    sha256 cellar: :any,                 arm64_sequoia: "f622f13047931100ca2dbddca229b532e3220ca5054b9c53a3aa67d84d7f34ce"
    sha256 cellar: :any,                 arm64_sonoma:  "f622f13047931100ca2dbddca229b532e3220ca5054b9c53a3aa67d84d7f34ce"
    sha256 cellar: :any,                 sonoma:        "e71ab43faaf70e769488747674bf6264773ac5855f04f108d3e4c6a90340833d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d084620f529ac04cb9f550121bccfe41efc22439a6713e2ee59a92519f8e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "598dceafa5c3c53aace913be8fe79b889534640aab9f08c855676ecde0f348f9"
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