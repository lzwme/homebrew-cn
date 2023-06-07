require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.5.tgz"
  sha256 "b47ce9e98fe9362b188f0531dbaa78905fc12e49b3ea81684fcb984b704123a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9626facc5b45cf57325f86ca0b08a5e8898f36549f2d6177ca04b8c8b0c2944a"
    sha256 cellar: :any,                 arm64_monterey: "9626facc5b45cf57325f86ca0b08a5e8898f36549f2d6177ca04b8c8b0c2944a"
    sha256 cellar: :any,                 arm64_big_sur:  "9626facc5b45cf57325f86ca0b08a5e8898f36549f2d6177ca04b8c8b0c2944a"
    sha256 cellar: :any,                 ventura:        "e01e1eb180fbb19050512143047b03f4a34dd1577fc39a699c66353588905fdc"
    sha256 cellar: :any,                 monterey:       "e01e1eb180fbb19050512143047b03f4a34dd1577fc39a699c66353588905fdc"
    sha256 cellar: :any,                 big_sur:        "e01e1eb180fbb19050512143047b03f4a34dd1577fc39a699c66353588905fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47730b485a94aa069b9b442b324d55cf763e1570f3066d41a9a9e70578743c9"
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