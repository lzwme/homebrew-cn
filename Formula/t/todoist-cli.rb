class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.2.1.tgz"
  sha256 "379df538294fab1942b57b205fc1abb9b40c7f86564d608165d6f351f377cd6a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6c4e1e8f27cb6e0008f207d8c719356016a9f4ab1ea81fe46cab1f637d7c089"
    sha256 cellar: :any,                 arm64_sequoia: "a6c4e1e8f27cb6e0008f207d8c719356016a9f4ab1ea81fe46cab1f637d7c089"
    sha256 cellar: :any,                 arm64_sonoma:  "a6c4e1e8f27cb6e0008f207d8c719356016a9f4ab1ea81fe46cab1f637d7c089"
    sha256 cellar: :any,                 sonoma:        "a1c9bb49ce3292928d4897b614637495241faba52e5787fd1e9224721198c85c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67fda62eff467ebe63d045d4b4d492b48159de55b5dac2d814dd2c0c6b73e2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8698c44e98b5f54d2eff305ca2e31ca8c2ddb21d37a95be3a0dad6215ccf0465"
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