require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.37.1.tgz"
  sha256 "bec84311c5024ca83485b19ade5e7eb496849c828ddeeb614e6c6bed90048d93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83720b62665b98ae5ee492f4132c32deed809fccbd2a7dbfb82755ed2bb6a6ec"
    sha256 cellar: :any,                 arm64_monterey: "83720b62665b98ae5ee492f4132c32deed809fccbd2a7dbfb82755ed2bb6a6ec"
    sha256 cellar: :any,                 arm64_big_sur:  "83720b62665b98ae5ee492f4132c32deed809fccbd2a7dbfb82755ed2bb6a6ec"
    sha256 cellar: :any,                 ventura:        "f22f22ecf2d42225537dc481a46a3a99a0da92d357a283637235fe277a5d2045"
    sha256 cellar: :any,                 monterey:       "f22f22ecf2d42225537dc481a46a3a99a0da92d357a283637235fe277a5d2045"
    sha256 cellar: :any,                 big_sur:        "f22f22ecf2d42225537dc481a46a3a99a0da92d357a283637235fe277a5d2045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53be04edd6dd4c0a9f8d9cbf3a426173a12608ef14e1a37f065be4ad30f81ce"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
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