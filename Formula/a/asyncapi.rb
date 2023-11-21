require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.60.4.tgz"
  sha256 "7ccf1ca8f22c54744dc53af6e98ccc1dfae9002f259ac4e0d1ae9ccd306732c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5dbdef39b6b7d79795acb335c0e44ecb553bc322c447af71be4c48f21c435685"
    sha256 cellar: :any,                 arm64_ventura:  "5dbdef39b6b7d79795acb335c0e44ecb553bc322c447af71be4c48f21c435685"
    sha256 cellar: :any,                 arm64_monterey: "5dbdef39b6b7d79795acb335c0e44ecb553bc322c447af71be4c48f21c435685"
    sha256 cellar: :any,                 sonoma:         "9108dede2501996233acdbbc687d8fd7dc6d579a2c60c45ab88ff58e00a63223"
    sha256 cellar: :any,                 ventura:        "9108dede2501996233acdbbc687d8fd7dc6d579a2c60c45ab88ff58e00a63223"
    sha256 cellar: :any,                 monterey:       "9108dede2501996233acdbbc687d8fd7dc6d579a2c60c45ab88ff58e00a63223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64158057941648df24382ad226017c008f52e185e7ebacc47df101a0039163f"
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