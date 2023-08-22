require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.1.tgz"
  sha256 "fb7e09f35addc9551bb7b291eed5dd2e97567ddf82bca7fa043869b938cb0c2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85475da26584d512852b0efa4c836c8c3f789bf8a47d8a0ff68c789c7a7d1690"
    sha256 cellar: :any,                 arm64_monterey: "85475da26584d512852b0efa4c836c8c3f789bf8a47d8a0ff68c789c7a7d1690"
    sha256 cellar: :any,                 arm64_big_sur:  "85475da26584d512852b0efa4c836c8c3f789bf8a47d8a0ff68c789c7a7d1690"
    sha256 cellar: :any,                 ventura:        "e6922d4653fe83c30e5e697b4a5bfdd192ada4b29c7b2bb0c8129d29303a9b7f"
    sha256 cellar: :any,                 monterey:       "e6922d4653fe83c30e5e697b4a5bfdd192ada4b29c7b2bb0c8129d29303a9b7f"
    sha256 cellar: :any,                 big_sur:        "e6922d4653fe83c30e5e697b4a5bfdd192ada4b29c7b2bb0c8129d29303a9b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f6f4dbd71afa49925d93675062f406546a1e7340f810697a692b9d1015ce04"
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