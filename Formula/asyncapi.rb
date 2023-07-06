require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.50.1.tgz"
  sha256 "213b95507d6f354e1f710aadbadd9a86bf65e22099623d4030f4a4442ef2f88c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b3f8c659db30da492cddb45a1a6e270f4177cedf6cedf0a54cf3447078796ae2"
    sha256 cellar: :any,                 arm64_monterey: "b3f8c659db30da492cddb45a1a6e270f4177cedf6cedf0a54cf3447078796ae2"
    sha256 cellar: :any,                 arm64_big_sur:  "b3f8c659db30da492cddb45a1a6e270f4177cedf6cedf0a54cf3447078796ae2"
    sha256 cellar: :any,                 ventura:        "094b33b208038b8bb2b01f8dc2134dd4273fd06c8e284916d0d672fdbb4cf6e8"
    sha256 cellar: :any,                 monterey:       "094b33b208038b8bb2b01f8dc2134dd4273fd06c8e284916d0d672fdbb4cf6e8"
    sha256 cellar: :any,                 big_sur:        "094b33b208038b8bb2b01f8dc2134dd4273fd06c8e284916d0d672fdbb4cf6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bbeb511700d1f74434b7ae408e768f4f581bc1a2eb4fdf739ba4273c0c13e3c"
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