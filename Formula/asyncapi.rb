require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.48.6.tgz"
  sha256 "538eb903e8ea6d1ccbfbd040e47c506bc44f8fa60b6f3f9b32e9448a1038a19e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa54ee7da47d9991227c794372f4f34f3d86fe44c9f2205981e85476c4f2d1f4"
    sha256 cellar: :any,                 arm64_monterey: "fa54ee7da47d9991227c794372f4f34f3d86fe44c9f2205981e85476c4f2d1f4"
    sha256 cellar: :any,                 arm64_big_sur:  "fa54ee7da47d9991227c794372f4f34f3d86fe44c9f2205981e85476c4f2d1f4"
    sha256 cellar: :any,                 ventura:        "81ad5c52d524a81ddd6ff217c0db1cff63d4372d42e8f1c107c1620a95b1b2d9"
    sha256 cellar: :any,                 monterey:       "81ad5c52d524a81ddd6ff217c0db1cff63d4372d42e8f1c107c1620a95b1b2d9"
    sha256 cellar: :any,                 big_sur:        "81ad5c52d524a81ddd6ff217c0db1cff63d4372d42e8f1c107c1620a95b1b2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2639c11e0065751ce4b720bf560e09acadeddf0bc054490cd98ccdf770396212"
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