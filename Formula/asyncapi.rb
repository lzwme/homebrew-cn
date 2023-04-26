require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.0.tgz"
  sha256 "99c79c4d3310c984d8df4a3b1003add485a38eed93ef8085508d85e1a4aef014"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61381a8947fa9a47a585e056a289f5266a42515d08906110a2a8beb2fb9c4d80"
    sha256 cellar: :any,                 arm64_monterey: "61381a8947fa9a47a585e056a289f5266a42515d08906110a2a8beb2fb9c4d80"
    sha256 cellar: :any,                 arm64_big_sur:  "61381a8947fa9a47a585e056a289f5266a42515d08906110a2a8beb2fb9c4d80"
    sha256 cellar: :any,                 ventura:        "cc1fa5136b1e3d25e7ee964145865e08734021eb4349c4a6c3ec1eb4b5602181"
    sha256 cellar: :any,                 monterey:       "2f59f537d2d3a164902b312608ee01fefcd89039f50ab5ec3e5f204672f0d3ed"
    sha256 cellar: :any,                 big_sur:        "cc1fa5136b1e3d25e7ee964145865e08734021eb4349c4a6c3ec1eb4b5602181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196de16ecddbd724d08715ff360cde4c63ebad6ef42cf21701bd7feba718b7ae"
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