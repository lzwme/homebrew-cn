require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.8.tgz"
  sha256 "6772cdfc03da4fcbaac237738b476c6367bd86ae941c014d7c04b6f5617f3b12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4429dfbfb5c876a6268102dbbf2401b323516ab04dbf2bbb70c03e78a6807c84"
    sha256 cellar: :any,                 arm64_ventura:  "4429dfbfb5c876a6268102dbbf2401b323516ab04dbf2bbb70c03e78a6807c84"
    sha256 cellar: :any,                 arm64_monterey: "4429dfbfb5c876a6268102dbbf2401b323516ab04dbf2bbb70c03e78a6807c84"
    sha256 cellar: :any,                 sonoma:         "49425d2e3f11054a4b257a1b1dca9ed2f681b8a62f7d6a3c27f0c677ae1d05bf"
    sha256 cellar: :any,                 ventura:        "49425d2e3f11054a4b257a1b1dca9ed2f681b8a62f7d6a3c27f0c677ae1d05bf"
    sha256 cellar: :any,                 monterey:       "49425d2e3f11054a4b257a1b1dca9ed2f681b8a62f7d6a3c27f0c677ae1d05bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c39ef216108d6c0bc0dd1caaf320d16d7bcdeee40d1bc970e044a3870d8cf33"
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