require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.45.5.tgz"
  sha256 "ae738f7db80e3052a3933351ea9b2098e466f5423ff0b06868ac0bead4f2c0ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "377ae52bb60ecbce824af816f711f061d29e309d368e5376a0ec55ddb693eb6c"
    sha256 cellar: :any,                 arm64_monterey: "bf68076f005a3c5e029b86f0b1d0f6567d22fb0df39d0c615af5e07ef24bce56"
    sha256 cellar: :any,                 arm64_big_sur:  "377ae52bb60ecbce824af816f711f061d29e309d368e5376a0ec55ddb693eb6c"
    sha256 cellar: :any,                 ventura:        "3b29acd2521410a5d3a8c79eb4721f317c828d7aa3ce8149ccb415d8e135dc18"
    sha256 cellar: :any,                 monterey:       "3b29acd2521410a5d3a8c79eb4721f317c828d7aa3ce8149ccb415d8e135dc18"
    sha256 cellar: :any,                 big_sur:        "3b29acd2521410a5d3a8c79eb4721f317c828d7aa3ce8149ccb415d8e135dc18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef17837281786cb33ee40575bc7c4df776f27c141b2d8dacaddcaaadd775b72"
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