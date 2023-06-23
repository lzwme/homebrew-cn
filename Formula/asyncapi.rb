require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.48.8.tgz"
  sha256 "e0d59adc0b40ca7267428f0b2931cbd732b64fd64e1ebfe127976c3b3586e594"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6498a4141b19ce216ef0b2154d6e938ad300422ee44863a092593fe2dbcaca0"
    sha256 cellar: :any,                 arm64_monterey: "c6498a4141b19ce216ef0b2154d6e938ad300422ee44863a092593fe2dbcaca0"
    sha256 cellar: :any,                 arm64_big_sur:  "c6498a4141b19ce216ef0b2154d6e938ad300422ee44863a092593fe2dbcaca0"
    sha256 cellar: :any,                 ventura:        "9aa8790c8e8044d97e4c8e5f7023c31ddfbd750ea8794891769baab181e54191"
    sha256 cellar: :any,                 monterey:       "9aa8790c8e8044d97e4c8e5f7023c31ddfbd750ea8794891769baab181e54191"
    sha256 cellar: :any,                 big_sur:        "9aa8790c8e8044d97e4c8e5f7023c31ddfbd750ea8794891769baab181e54191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29c158085607b901f5cd6135823dea597a14dd9efc6341ed2e07f20c236e2ed6"
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