require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.5.tgz"
  sha256 "e90711835326cf958cf693624ced33afd9f6c665be08cb3fd3addee4472732c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f96ebb903c56a1ae01c58b7e5524a31fba3c1851c63e51148deab77711d67b02"
    sha256 cellar: :any,                 arm64_ventura:  "f96ebb903c56a1ae01c58b7e5524a31fba3c1851c63e51148deab77711d67b02"
    sha256 cellar: :any,                 arm64_monterey: "f96ebb903c56a1ae01c58b7e5524a31fba3c1851c63e51148deab77711d67b02"
    sha256 cellar: :any,                 sonoma:         "182689dd0d0273175a43b16a3cdb70e18fa3695f71d9bb29ca28daf7ad340295"
    sha256 cellar: :any,                 ventura:        "182689dd0d0273175a43b16a3cdb70e18fa3695f71d9bb29ca28daf7ad340295"
    sha256 cellar: :any,                 monterey:       "182689dd0d0273175a43b16a3cdb70e18fa3695f71d9bb29ca28daf7ad340295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e9516d1ec27e4415192b7ca4d21eb6fdb11c338e5d95570ceea1e7cfac0236"
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