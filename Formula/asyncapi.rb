require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.13.tgz"
  sha256 "1d2a3f6c1325ec6ff0e5e5a419b470575d8667a8aeb0ac3a32b5c0f1522f106d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "299feac01c590c58f3236beaaee80dccf39ac77a68d7fc91b4aae684e8d80cb8"
    sha256 cellar: :any,                 arm64_monterey: "299feac01c590c58f3236beaaee80dccf39ac77a68d7fc91b4aae684e8d80cb8"
    sha256 cellar: :any,                 arm64_big_sur:  "299feac01c590c58f3236beaaee80dccf39ac77a68d7fc91b4aae684e8d80cb8"
    sha256 cellar: :any,                 ventura:        "06e66689dee5f5c9eeb3d7d4ec517dcd11e7506f7eddff699f292e6b535c48ec"
    sha256 cellar: :any,                 monterey:       "06e66689dee5f5c9eeb3d7d4ec517dcd11e7506f7eddff699f292e6b535c48ec"
    sha256 cellar: :any,                 big_sur:        "06e66689dee5f5c9eeb3d7d4ec517dcd11e7506f7eddff699f292e6b535c48ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e3b2811c7bec90fa448b71f9ed36029e1214281b01771e9dc3dff43519545b3"
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