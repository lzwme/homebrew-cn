require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.3.tgz"
  sha256 "fc727dbe569a0fe60d41aa1342d18cae446f509b0db55e6faada8cf36f14f76c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d282e2ace5b393769b6aae6ed886533c71fdce668bffba1bd4c7ef3a964f429e"
    sha256 cellar: :any,                 arm64_monterey: "d282e2ace5b393769b6aae6ed886533c71fdce668bffba1bd4c7ef3a964f429e"
    sha256 cellar: :any,                 arm64_big_sur:  "d282e2ace5b393769b6aae6ed886533c71fdce668bffba1bd4c7ef3a964f429e"
    sha256 cellar: :any,                 ventura:        "341b806f5466babc2948f37ecf71627cd20364e7bfbbf8a2963938a3428bdbd6"
    sha256 cellar: :any,                 monterey:       "341b806f5466babc2948f37ecf71627cd20364e7bfbbf8a2963938a3428bdbd6"
    sha256 cellar: :any,                 big_sur:        "341b806f5466babc2948f37ecf71627cd20364e7bfbbf8a2963938a3428bdbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e3081e83a30951b72e195082062d20343d29f999798981d781eceb356d5c95b"
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