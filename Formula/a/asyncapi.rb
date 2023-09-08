require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.7.tgz"
  sha256 "0c2a67b2134eb5894cc618a38e8a13d590416c7de6f4b4c89ed846904685d3ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ede5b6eb88948d29ce4cb0e249709ee3a4a1842b043df76dd52df5f0f884946"
    sha256 cellar: :any,                 arm64_monterey: "2ede5b6eb88948d29ce4cb0e249709ee3a4a1842b043df76dd52df5f0f884946"
    sha256 cellar: :any,                 arm64_big_sur:  "2ede5b6eb88948d29ce4cb0e249709ee3a4a1842b043df76dd52df5f0f884946"
    sha256 cellar: :any,                 ventura:        "b33c8bcb57c4bb9ada42441783e778efcec228cee1cba9439527d3d1efcb684e"
    sha256 cellar: :any,                 monterey:       "b33c8bcb57c4bb9ada42441783e778efcec228cee1cba9439527d3d1efcb684e"
    sha256 cellar: :any,                 big_sur:        "b33c8bcb57c4bb9ada42441783e778efcec228cee1cba9439527d3d1efcb684e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d1c9ce0891500e15998f4a7d61c9b7a7b24bfb408dbd663952789d6ab4bfb5"
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