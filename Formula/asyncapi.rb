require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.4.tgz"
  sha256 "54a451e7d8e560adc4bdf2c635f30403d284620fa53bc73b5037323170d0cf04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00a8a701cd08851bed675d1e8ebb043a0f120ac1438bee80a2da493c87191bb9"
    sha256 cellar: :any,                 arm64_monterey: "00a8a701cd08851bed675d1e8ebb043a0f120ac1438bee80a2da493c87191bb9"
    sha256 cellar: :any,                 arm64_big_sur:  "00a8a701cd08851bed675d1e8ebb043a0f120ac1438bee80a2da493c87191bb9"
    sha256 cellar: :any,                 ventura:        "b931bdb43f10bf9d8231f43a5cdc0394b24c951568cb1f237c8997d4068b086a"
    sha256 cellar: :any,                 monterey:       "b931bdb43f10bf9d8231f43a5cdc0394b24c951568cb1f237c8997d4068b086a"
    sha256 cellar: :any,                 big_sur:        "b931bdb43f10bf9d8231f43a5cdc0394b24c951568cb1f237c8997d4068b086a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff22fe3ef36ca1aa370f68925cef4cb11b8672834020418574477a3e3ad96087"
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