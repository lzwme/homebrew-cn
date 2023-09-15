require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.56.2.tgz"
  sha256 "55bde75030eb25f9d8ce749ecf1d1d3035c47dcd89123df7536ae17a14821d96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e8a81fa03c2505398fd25e2cbdb9950a1ef8034326823b67477572c6d2a645b"
    sha256 cellar: :any,                 arm64_monterey: "6e8a81fa03c2505398fd25e2cbdb9950a1ef8034326823b67477572c6d2a645b"
    sha256 cellar: :any,                 arm64_big_sur:  "6e8a81fa03c2505398fd25e2cbdb9950a1ef8034326823b67477572c6d2a645b"
    sha256 cellar: :any,                 ventura:        "f77b735117bac320a3191970909edceaf583cef1eaefe1c0e31998b46311c017"
    sha256 cellar: :any,                 monterey:       "d2b6e8040c438cf59ab4773bcdb39c9fc77dd14d22fc932d108b3b8bc1f3780f"
    sha256 cellar: :any,                 big_sur:        "d2b6e8040c438cf59ab4773bcdb39c9fc77dd14d22fc932d108b3b8bc1f3780f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f30101d2df17c059418cd68ebd50b2babbc93760bb8c51632d46202d88ca3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end