require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.1.tgz"
  sha256 "9f1a40c3961e1d765e9095e42d1830b600955024762615bbb28e7fd9ed6330a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2beede8e20391df58945ba2cb8536270762917b62e8d801d4c01581cccd2389a"
    sha256 cellar: :any,                 arm64_ventura:  "2beede8e20391df58945ba2cb8536270762917b62e8d801d4c01581cccd2389a"
    sha256 cellar: :any,                 arm64_monterey: "2beede8e20391df58945ba2cb8536270762917b62e8d801d4c01581cccd2389a"
    sha256 cellar: :any,                 sonoma:         "f7dbd81cd3131c5a4b10909cc9e2030ddcf94acbfec419957c5c4e67415628f3"
    sha256 cellar: :any,                 ventura:        "f7dbd81cd3131c5a4b10909cc9e2030ddcf94acbfec419957c5c4e67415628f3"
    sha256 cellar: :any,                 monterey:       "f7dbd81cd3131c5a4b10909cc9e2030ddcf94acbfec419957c5c4e67415628f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2daf15b89c87b89f45e09b234931e3745070fd331a2567fa29474626878d8e4"
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