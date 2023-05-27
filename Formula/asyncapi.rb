require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.44.2.tgz"
  sha256 "56668d1af167090b123b563da17f35b5c3be9df404058467ca4f14244b22c520"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c339842d4144d2b21ed53233611f82d165ac1b4ce7d8470a3a958a6c6f5fdf2"
    sha256 cellar: :any,                 arm64_monterey: "9c339842d4144d2b21ed53233611f82d165ac1b4ce7d8470a3a958a6c6f5fdf2"
    sha256 cellar: :any,                 arm64_big_sur:  "9c339842d4144d2b21ed53233611f82d165ac1b4ce7d8470a3a958a6c6f5fdf2"
    sha256 cellar: :any,                 ventura:        "e23b10a50c81348a25d4f63ba2f8c9568f0df9017931afc702c2633d57b8b553"
    sha256 cellar: :any,                 monterey:       "e23b10a50c81348a25d4f63ba2f8c9568f0df9017931afc702c2633d57b8b553"
    sha256 cellar: :any,                 big_sur:        "e23b10a50c81348a25d4f63ba2f8c9568f0df9017931afc702c2633d57b8b553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d168799a4d29446462b14205becd071fed0a815297f34cbc7f4ddcf178e9afe"
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