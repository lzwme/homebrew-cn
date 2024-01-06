require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.0.2.tgz"
  sha256 "6003db305a39dd9172741a19fb60f79d76db9f84df57240c3b0cbab3a770c7f2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d79e4eea10c4a2879ecf474dc3819a99bda521d347c50237f6d1667d423ac82b"
    sha256 cellar: :any,                 arm64_ventura:  "d79e4eea10c4a2879ecf474dc3819a99bda521d347c50237f6d1667d423ac82b"
    sha256 cellar: :any,                 arm64_monterey: "d79e4eea10c4a2879ecf474dc3819a99bda521d347c50237f6d1667d423ac82b"
    sha256 cellar: :any,                 sonoma:         "4a88d99fed0ee245c27ba6397f4b3eef51c6349d987c9618e562fafa9be61feb"
    sha256 cellar: :any,                 ventura:        "4a88d99fed0ee245c27ba6397f4b3eef51c6349d987c9618e562fafa9be61feb"
    sha256 cellar: :any,                 monterey:       "4a88d99fed0ee245c27ba6397f4b3eef51c6349d987c9618e562fafa9be61feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9035f1f30420bf1f12b0cd92bd7e787403c45b97d11727ff87e0681928a07e1a"
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