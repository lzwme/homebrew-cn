class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.75.3.tgz"
  sha256 "ecd5ce020f87394d058fbc1196244e3d9376cd589c8fb3e63003a8ee169f8080"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "285a8642c0727ff74819dd410148869d2e31c19f5a8cf974743b50ddd56112fd"
    sha256 cellar: :any,                 arm64_sequoia: "62f68b3b49a5c10b7c890b8ad9a770ccf086f540fc0c095e6557a2e30aa56098"
    sha256 cellar: :any,                 arm64_sonoma:  "62f68b3b49a5c10b7c890b8ad9a770ccf086f540fc0c095e6557a2e30aa56098"
    sha256 cellar: :any,                 sonoma:        "a03419e1a211ef24539e4ddd2b6be34ce1658b1c6c6f9b36b7d2e3e1aafadd0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03802866112ba28d13fbfdb2ef28e1c6ba08804c32c43786c502d09db9e91159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f22a0c904e71af90e0340535253d3be5c14d1579a33e3a19a9bbb5fe8137e38"
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