require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.4.tgz"
  sha256 "6a2e6b08c95daabe6fbc990fa15959626e47cec5ddaaf900699dc53210692c11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6a4bf437598a565f444dd79e1bf73da2b711b379e745508b67c9519acc30263"
    sha256 cellar: :any,                 arm64_monterey: "b6a4bf437598a565f444dd79e1bf73da2b711b379e745508b67c9519acc30263"
    sha256 cellar: :any,                 arm64_big_sur:  "b6a4bf437598a565f444dd79e1bf73da2b711b379e745508b67c9519acc30263"
    sha256 cellar: :any,                 ventura:        "e8c1f79c8abc5ef69965df06b45f6fc66d8ca1f100d4094bc9fbefd4842493a3"
    sha256 cellar: :any,                 monterey:       "e8c1f79c8abc5ef69965df06b45f6fc66d8ca1f100d4094bc9fbefd4842493a3"
    sha256 cellar: :any,                 big_sur:        "e8c1f79c8abc5ef69965df06b45f6fc66d8ca1f100d4094bc9fbefd4842493a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5c6864f45afc8c184f348fc841a02c663f2b24b250c439883c7746965bc29b"
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