require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.31.2.tgz"
  sha256 "77a147f5457ecdfd96f8bddfbcfbd5d9dbc29fc05d2126947b5073f9ba3cb562"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc3077c2ea4b9cef56c455f7b370d29d30a92a8095c3ce14d9d3ee26badb6180"
    sha256 cellar: :any,                 arm64_monterey: "bc3077c2ea4b9cef56c455f7b370d29d30a92a8095c3ce14d9d3ee26badb6180"
    sha256 cellar: :any,                 arm64_big_sur:  "bc3077c2ea4b9cef56c455f7b370d29d30a92a8095c3ce14d9d3ee26badb6180"
    sha256 cellar: :any,                 ventura:        "77033987744381b9e3179f7b5f09ea9d00a15cbcba397e26965064ed37e7fdff"
    sha256 cellar: :any,                 monterey:       "77033987744381b9e3179f7b5f09ea9d00a15cbcba397e26965064ed37e7fdff"
    sha256 cellar: :any,                 big_sur:        "77033987744381b9e3179f7b5f09ea9d00a15cbcba397e26965064ed37e7fdff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f2cf045bc2ab390ec25fcaedaa60a422ef5d8304f823d4a82c20fd2216aa5c"
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