require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.31.3.tgz"
  sha256 "a19a5514ce41a0ddf793a5c07deba1d239760c4970b7b79ba6a75bbcbe19b90e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "137baea763780226c92d9c75603f6cd60d66dff5cb6692208ac9b5cfb5799187"
    sha256 cellar: :any,                 arm64_monterey: "137baea763780226c92d9c75603f6cd60d66dff5cb6692208ac9b5cfb5799187"
    sha256 cellar: :any,                 arm64_big_sur:  "137baea763780226c92d9c75603f6cd60d66dff5cb6692208ac9b5cfb5799187"
    sha256 cellar: :any,                 ventura:        "85f012d4c97d910fdf0b75c3f16760f67d21f98bad0fac934b68f043a61f7f71"
    sha256 cellar: :any,                 monterey:       "85f012d4c97d910fdf0b75c3f16760f67d21f98bad0fac934b68f043a61f7f71"
    sha256 cellar: :any,                 big_sur:        "85f012d4c97d910fdf0b75c3f16760f67d21f98bad0fac934b68f043a61f7f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5820b65b8c9af92bdbc01dfc5f68d3bd5969badea9c81818fb04248678d5c4"
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