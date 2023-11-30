require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.9.tgz"
  sha256 "ea713467f0729065e657d7a1c369368fa297afce9cf9e189d880dd67e9f39853"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7570c3be2bbd3503cc0198e4c54d481f34d441ff3e7c8877970e607b3c654c54"
    sha256 cellar: :any,                 arm64_ventura:  "7570c3be2bbd3503cc0198e4c54d481f34d441ff3e7c8877970e607b3c654c54"
    sha256 cellar: :any,                 arm64_monterey: "7570c3be2bbd3503cc0198e4c54d481f34d441ff3e7c8877970e607b3c654c54"
    sha256 cellar: :any,                 sonoma:         "96370d175fa07801de7d2be306a7daff516454723acd71ed76592143bb62ff1f"
    sha256 cellar: :any,                 ventura:        "96370d175fa07801de7d2be306a7daff516454723acd71ed76592143bb62ff1f"
    sha256 cellar: :any,                 monterey:       "96370d175fa07801de7d2be306a7daff516454723acd71ed76592143bb62ff1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aff2c3b73032a2b0a220285b7323e117e69ad1ceb61dad0e11a2098552c7c47b"
  end

  depends_on "node"

  def install
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