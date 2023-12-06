require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.10.tgz"
  sha256 "460494d69de0e587ebcaac663f2542b5f16dc4df79dee34c3655bda6a8c29ae6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3edd6509fcac77dd65fc26eb82ae06ec45f355ae7aaf2a96aea8f077bf0cf948"
    sha256 cellar: :any,                 arm64_ventura:  "3edd6509fcac77dd65fc26eb82ae06ec45f355ae7aaf2a96aea8f077bf0cf948"
    sha256 cellar: :any,                 arm64_monterey: "3edd6509fcac77dd65fc26eb82ae06ec45f355ae7aaf2a96aea8f077bf0cf948"
    sha256 cellar: :any,                 sonoma:         "965404d03cbfe41da2f5a68d800a3c771fb27fe2001544b8511d0a0c886a4c96"
    sha256 cellar: :any,                 ventura:        "965404d03cbfe41da2f5a68d800a3c771fb27fe2001544b8511d0a0c886a4c96"
    sha256 cellar: :any,                 monterey:       "965404d03cbfe41da2f5a68d800a3c771fb27fe2001544b8511d0a0c886a4c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99b32c605a418c00e374c9aa43013ba225299868efcfc12daa9e5e0692c0ef5"
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