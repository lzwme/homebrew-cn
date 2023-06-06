require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.1.tgz"
  sha256 "df5a7766f0c57bc74707d7078ec7fb971141a101dbd78f5c41d4f3064400c646"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1e759ed27481a980238afeae3a00b79746198c516e186ce4b6601a4a6ffb17e"
    sha256 cellar: :any,                 arm64_monterey: "d1e759ed27481a980238afeae3a00b79746198c516e186ce4b6601a4a6ffb17e"
    sha256 cellar: :any,                 arm64_big_sur:  "d1e759ed27481a980238afeae3a00b79746198c516e186ce4b6601a4a6ffb17e"
    sha256 cellar: :any,                 ventura:        "0f693c4d6d9481b64361f5e60785ff2bfd2656f117e2c0f8e8ee9ef20d38e6d1"
    sha256 cellar: :any,                 monterey:       "0f693c4d6d9481b64361f5e60785ff2bfd2656f117e2c0f8e8ee9ef20d38e6d1"
    sha256 cellar: :any,                 big_sur:        "0f693c4d6d9481b64361f5e60785ff2bfd2656f117e2c0f8e8ee9ef20d38e6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b5812d2571ec1f5f40a6d2ca45b058018406dfafcc41f071635c46dcd7e8ec1"
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