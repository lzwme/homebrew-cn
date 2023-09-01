require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.4.tgz"
  sha256 "81bcc1f90cfec9de401d9be340f58452ae051ae315d273d802ba6be9c8b8663f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6414b7d7955ba76c9744d29b58cf0f41e2b2ae5c8174a97a7e51c1a11abf1fad"
    sha256 cellar: :any,                 arm64_monterey: "6414b7d7955ba76c9744d29b58cf0f41e2b2ae5c8174a97a7e51c1a11abf1fad"
    sha256 cellar: :any,                 arm64_big_sur:  "6414b7d7955ba76c9744d29b58cf0f41e2b2ae5c8174a97a7e51c1a11abf1fad"
    sha256 cellar: :any,                 ventura:        "573a6d6c1b8d6371efbc947a4fa16460f972e8391f68905fb61a57934ecf6180"
    sha256 cellar: :any,                 monterey:       "573a6d6c1b8d6371efbc947a4fa16460f972e8391f68905fb61a57934ecf6180"
    sha256 cellar: :any,                 big_sur:        "573a6d6c1b8d6371efbc947a4fa16460f972e8391f68905fb61a57934ecf6180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a850550baa849dbd437348ae836382d52a16bf780bca256bdfc6f17b1b1dad"
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