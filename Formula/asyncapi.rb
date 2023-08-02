require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.7.tgz"
  sha256 "bd679443dd9534d7630e6b9d1457a41ea8a0cde403067c09d6eb84fd5181be67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1747c92a3bf37eed758648888045bc1db8662d9e15a85bd2155a52d3babaa9fd"
    sha256 cellar: :any,                 arm64_monterey: "1747c92a3bf37eed758648888045bc1db8662d9e15a85bd2155a52d3babaa9fd"
    sha256 cellar: :any,                 arm64_big_sur:  "1747c92a3bf37eed758648888045bc1db8662d9e15a85bd2155a52d3babaa9fd"
    sha256 cellar: :any,                 ventura:        "42fb008fdc2de1c9f190ba3719fdd7c117351c6727794930ee83d6c6263901fb"
    sha256 cellar: :any,                 monterey:       "42fb008fdc2de1c9f190ba3719fdd7c117351c6727794930ee83d6c6263901fb"
    sha256 cellar: :any,                 big_sur:        "42fb008fdc2de1c9f190ba3719fdd7c117351c6727794930ee83d6c6263901fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142ff986d27c49e499bdb70c6fdb3f28f105ac779e877d9cd965cd5c251d1e9b"
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