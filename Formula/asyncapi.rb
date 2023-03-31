require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.36.0.tgz"
  sha256 "242306044aada8bf1fe07438ad6e116e1a0a22d18351901470b2a263a43658d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "442f78e80e1e70c86bd142206dd9ba4b17fd939443f51c48495f72dad0c59bd0"
    sha256 cellar: :any,                 arm64_monterey: "442f78e80e1e70c86bd142206dd9ba4b17fd939443f51c48495f72dad0c59bd0"
    sha256 cellar: :any,                 arm64_big_sur:  "442f78e80e1e70c86bd142206dd9ba4b17fd939443f51c48495f72dad0c59bd0"
    sha256 cellar: :any,                 ventura:        "093483e8d0803852c105b0e8e518264d0e7ed18a67151d025d52cd326c988c72"
    sha256 cellar: :any,                 monterey:       "093483e8d0803852c105b0e8e518264d0e7ed18a67151d025d52cd326c988c72"
    sha256 cellar: :any,                 big_sur:        "093483e8d0803852c105b0e8e518264d0e7ed18a67151d025d52cd326c988c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90452031b0494ff82409852a8fa3acfe116df6f2910dc75593cf1d543b54d7e4"
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