require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.8.tgz"
  sha256 "9ee4b4cc1783c697a472a006eb65f0506217b76bbd20406a24e3af74a3bb3233"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ebc5ec4110dfba73c0db1022c0d0dc045958b9d013f047c513b4a7ae7a7144c"
    sha256 cellar: :any,                 arm64_ventura:  "3ebc5ec4110dfba73c0db1022c0d0dc045958b9d013f047c513b4a7ae7a7144c"
    sha256 cellar: :any,                 arm64_monterey: "3ebc5ec4110dfba73c0db1022c0d0dc045958b9d013f047c513b4a7ae7a7144c"
    sha256 cellar: :any,                 sonoma:         "d584419b7571a803b444f335747130a5753fb092b5d1a0ab4411d55f2e7229dd"
    sha256 cellar: :any,                 ventura:        "d584419b7571a803b444f335747130a5753fb092b5d1a0ab4411d55f2e7229dd"
    sha256 cellar: :any,                 monterey:       "d584419b7571a803b444f335747130a5753fb092b5d1a0ab4411d55f2e7229dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b744f00cd4adc63aa58322e80e86b004a4f675c29c38eecb6af598f5ade71a"
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