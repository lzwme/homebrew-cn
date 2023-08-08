require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.52.1.tgz"
  sha256 "0bbf36ddc1b66915643cc13d72128f387e1a9ff81e6a54c3ef05b353ce487794"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c008816360426f937ee3e21b50a7649418ba252796b49b21a221fdb002e34468"
    sha256 cellar: :any,                 arm64_monterey: "c008816360426f937ee3e21b50a7649418ba252796b49b21a221fdb002e34468"
    sha256 cellar: :any,                 arm64_big_sur:  "c008816360426f937ee3e21b50a7649418ba252796b49b21a221fdb002e34468"
    sha256 cellar: :any,                 ventura:        "4f50abe1e2e04147cb79588f20e15b7f30c513cc5dcfceeb650fdc40ac27e950"
    sha256 cellar: :any,                 monterey:       "4f50abe1e2e04147cb79588f20e15b7f30c513cc5dcfceeb650fdc40ac27e950"
    sha256 cellar: :any,                 big_sur:        "4f50abe1e2e04147cb79588f20e15b7f30c513cc5dcfceeb650fdc40ac27e950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66fc4e9043b9aee37936c20db0807309ab6fb9da7b6f6835f5995e733615cd39"
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