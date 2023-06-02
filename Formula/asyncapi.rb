require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.46.0.tgz"
  sha256 "d6866bfac4679648dc28ecb443dde70c51e4206e28299d8363711ead542ad76e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ffcbfcb5076842e4ae09e872d0923013c561d5ea972b28157cf9ab1c404ab071"
    sha256 cellar: :any,                 arm64_monterey: "1cb6ab31eef2c8fded20a8c498b56a54ea6bb35899d4d375bce1ccb7d3559f65"
    sha256 cellar: :any,                 arm64_big_sur:  "ffcbfcb5076842e4ae09e872d0923013c561d5ea972b28157cf9ab1c404ab071"
    sha256 cellar: :any,                 ventura:        "1234ef1b8a329147c4615570939f15343f41e27c72eed02cd558c96f536988df"
    sha256 cellar: :any,                 monterey:       "1234ef1b8a329147c4615570939f15343f41e27c72eed02cd558c96f536988df"
    sha256 cellar: :any,                 big_sur:        "1234ef1b8a329147c4615570939f15343f41e27c72eed02cd558c96f536988df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84e9e48dcfade4c5fb19fda62f3fb4bd3cc234d548f86ba564f680b182fce2e"
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