require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.34.0.tgz"
  sha256 "96cb089fd47c53d521473473740f6c737e39079af71300df7a40ce381b29e642"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c101d73d6f9b95de2bba7ea51069db0daf2d82f6be173b9f3ccb18affdc60bb0"
    sha256 cellar: :any,                 arm64_monterey: "c101d73d6f9b95de2bba7ea51069db0daf2d82f6be173b9f3ccb18affdc60bb0"
    sha256 cellar: :any,                 arm64_big_sur:  "c101d73d6f9b95de2bba7ea51069db0daf2d82f6be173b9f3ccb18affdc60bb0"
    sha256 cellar: :any,                 ventura:        "c5c2aa265dda323e25c4bee3008c01193e72cd93bf1c21c6cffacfbd1bac4a0c"
    sha256 cellar: :any,                 monterey:       "c5c2aa265dda323e25c4bee3008c01193e72cd93bf1c21c6cffacfbd1bac4a0c"
    sha256 cellar: :any,                 big_sur:        "c5c2aa265dda323e25c4bee3008c01193e72cd93bf1c21c6cffacfbd1bac4a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89abcf5e9e6b7c59d78a5d7423af462652f45bf5f4b9e90dcc3a78a648f8383c"
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