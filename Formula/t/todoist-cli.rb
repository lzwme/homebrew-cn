class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.73.1.tgz"
  sha256 "d3685962859237f3b35e36e15ddcae1ab0c1888ad15ecd0a91cdbfb212c71963"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18da2323cfc67832a18da8af27fea0277d4a575cae6421a868b4e1eb3f53055d"
    sha256 cellar: :any,                 arm64_sequoia: "7ef32a680d25b06d3bb7faec443fcf4e204811bb4cfc461847b8ecfed223fda9"
    sha256 cellar: :any,                 arm64_sonoma:  "7ef32a680d25b06d3bb7faec443fcf4e204811bb4cfc461847b8ecfed223fda9"
    sha256 cellar: :any,                 sonoma:        "c52ee38f058b6e45f4fa4372d9177f5a9cb88e58c16a05fc5d656dcd6ace3258"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ce8382f62a5209dc8616e13277a112999af117a5783788abc08f9df1ef28dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8dfacf19a69838ce9036204814552f2b08b5758518306f5c1f2d2e2241f0de8"
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