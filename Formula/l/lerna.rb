require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.0.0.tgz"
  sha256 "0d70a1e9df20ab272731aaba9a925b69e7bd10c548ecb69f4eb825773a5dd51c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "531365645053ec9daf89624f297f213d112fd2297a2b1c365a9ff1914a8cf1d7"
    sha256 cellar: :any,                 arm64_ventura:  "531365645053ec9daf89624f297f213d112fd2297a2b1c365a9ff1914a8cf1d7"
    sha256 cellar: :any,                 arm64_monterey: "531365645053ec9daf89624f297f213d112fd2297a2b1c365a9ff1914a8cf1d7"
    sha256 cellar: :any,                 sonoma:         "aaa539a15be2d8c3c903a2483ae9386e41d967d3b67cfaa56c60656663134be1"
    sha256 cellar: :any,                 ventura:        "aaa539a15be2d8c3c903a2483ae9386e41d967d3b67cfaa56c60656663134be1"
    sha256 cellar: :any,                 monterey:       "aaa539a15be2d8c3c903a2483ae9386e41d967d3b67cfaa56c60656663134be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e86e5e1ddc39792f380a815ab68be77d17daf76458e84d9db65de7f68056f0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@nx/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end