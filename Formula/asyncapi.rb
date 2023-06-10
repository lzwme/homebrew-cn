require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.9.tgz"
  sha256 "3e9fa702b889de5d6f5e14be0a6a866fa5c4eb2d3688296b65f897a9cb3fa038"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "240917c34e7040022fb3a58bb4f8b9823190a0c6cd22a39ede28c97f089327ae"
    sha256 cellar: :any,                 arm64_monterey: "240917c34e7040022fb3a58bb4f8b9823190a0c6cd22a39ede28c97f089327ae"
    sha256 cellar: :any,                 arm64_big_sur:  "240917c34e7040022fb3a58bb4f8b9823190a0c6cd22a39ede28c97f089327ae"
    sha256 cellar: :any,                 ventura:        "a9be5a13168c17018c120ff07d448e4715d5efa20e1c8f44f1824856656b3429"
    sha256 cellar: :any,                 monterey:       "a9be5a13168c17018c120ff07d448e4715d5efa20e1c8f44f1824856656b3429"
    sha256 cellar: :any,                 big_sur:        "a9be5a13168c17018c120ff07d448e4715d5efa20e1c8f44f1824856656b3429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5145855cb6c9496a293d64231ae8da6a69396c6314037c146d49f44a1b511272"
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