require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.0.tgz"
  sha256 "40e1749b264d1b7a0275df73b1478bc4785a672cf6ceb02acea1bd06649270ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9bb0ea11020b43411db50c33a0ac182a77883148356ab3e1f6279742580e9ff1"
    sha256 cellar: :any,                 arm64_monterey: "9bb0ea11020b43411db50c33a0ac182a77883148356ab3e1f6279742580e9ff1"
    sha256 cellar: :any,                 arm64_big_sur:  "9bb0ea11020b43411db50c33a0ac182a77883148356ab3e1f6279742580e9ff1"
    sha256 cellar: :any,                 ventura:        "dcd8c8879f2d5cef06f16e6d156268356985ea8d7626a9cdefb78371c73ff262"
    sha256 cellar: :any,                 monterey:       "dcd8c8879f2d5cef06f16e6d156268356985ea8d7626a9cdefb78371c73ff262"
    sha256 cellar: :any,                 big_sur:        "dcd8c8879f2d5cef06f16e6d156268356985ea8d7626a9cdefb78371c73ff262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9193cb838f8fd23d75a8138e8b948ef3d971f770937a645730dcf6a515bcf887"
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