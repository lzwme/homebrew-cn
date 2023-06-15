require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.48.2.tgz"
  sha256 "bc5108788d3a8a89bfdf2485b4ca90f46b947e3c621e1b0e7aa3a73ab166e8f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77c128cf5c724f430a022fddd585f54412e785c7ff2d755b84c427148a5bf4b4"
    sha256 cellar: :any,                 arm64_monterey: "77c128cf5c724f430a022fddd585f54412e785c7ff2d755b84c427148a5bf4b4"
    sha256 cellar: :any,                 arm64_big_sur:  "77c128cf5c724f430a022fddd585f54412e785c7ff2d755b84c427148a5bf4b4"
    sha256 cellar: :any,                 ventura:        "77bdae66b509544109c3d40dc67d385581269cf2e847481037506fc3f5a8d3e3"
    sha256 cellar: :any,                 monterey:       "77bdae66b509544109c3d40dc67d385581269cf2e847481037506fc3f5a8d3e3"
    sha256 cellar: :any,                 big_sur:        "77bdae66b509544109c3d40dc67d385581269cf2e847481037506fc3f5a8d3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208af2bf54018dec042e5fad2f71d203d01f9eb254541b24f43bac7382aadd9c"
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