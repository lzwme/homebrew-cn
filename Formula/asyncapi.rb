require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.44.1.tgz"
  sha256 "bb302d8af88ab553c0c397c7354c7938f1f07790ee99b0d08087c71e4019dc5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7eea640a0afdb2cdcb0973d93b11590a8fe333f687996d0fca31b8a3471f159"
    sha256 cellar: :any,                 arm64_monterey: "a7eea640a0afdb2cdcb0973d93b11590a8fe333f687996d0fca31b8a3471f159"
    sha256 cellar: :any,                 arm64_big_sur:  "a7eea640a0afdb2cdcb0973d93b11590a8fe333f687996d0fca31b8a3471f159"
    sha256 cellar: :any,                 ventura:        "8513901ca19bac84cc31d28e31ba6aefccac93049df91f225cc50662f02588a4"
    sha256 cellar: :any,                 monterey:       "8513901ca19bac84cc31d28e31ba6aefccac93049df91f225cc50662f02588a4"
    sha256 cellar: :any,                 big_sur:        "8513901ca19bac84cc31d28e31ba6aefccac93049df91f225cc50662f02588a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff89e657cf8784c520f8417006ca764b744508a7bd5a1455e534774f67bd2dcb"
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