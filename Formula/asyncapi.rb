require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.44.0.tgz"
  sha256 "6b429ca8ab014a1c88f79228b62eb44ad9ab17ddbedc89bdee37a84e4a944a1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8aa4540bb43bd716bd00afae0ee08f02a6a3e64ff64bc4303aded100b96f8e0"
    sha256 cellar: :any,                 arm64_monterey: "b8aa4540bb43bd716bd00afae0ee08f02a6a3e64ff64bc4303aded100b96f8e0"
    sha256 cellar: :any,                 arm64_big_sur:  "b8aa4540bb43bd716bd00afae0ee08f02a6a3e64ff64bc4303aded100b96f8e0"
    sha256 cellar: :any,                 ventura:        "8f5e19a74a08e2e68a858176f230abf4cb3acc10e7de1e581ebd9accb70e5128"
    sha256 cellar: :any,                 monterey:       "8f5e19a74a08e2e68a858176f230abf4cb3acc10e7de1e581ebd9accb70e5128"
    sha256 cellar: :any,                 big_sur:        "8f5e19a74a08e2e68a858176f230abf4cb3acc10e7de1e581ebd9accb70e5128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ec8951d62ea37453445ac05691281e7e9f68c0fefc31b1e0f4fadec93bbe54"
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