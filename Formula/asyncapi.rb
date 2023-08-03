require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.8.tgz"
  sha256 "74d4472ffc9b79aaead9f88883f15a7eb3d024c0e23f05c1a7ac35f9839c3856"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03961d0914a36280e80077a092303f2529c532be5bef6fecc4d51108ec28e0b9"
    sha256 cellar: :any,                 arm64_monterey: "03961d0914a36280e80077a092303f2529c532be5bef6fecc4d51108ec28e0b9"
    sha256 cellar: :any,                 arm64_big_sur:  "03961d0914a36280e80077a092303f2529c532be5bef6fecc4d51108ec28e0b9"
    sha256 cellar: :any,                 ventura:        "82a21cdd3acd75fd1a180e99f032f25dbb2a1e7f6dfb31efc81957a1cf3b8a8a"
    sha256 cellar: :any,                 monterey:       "82a21cdd3acd75fd1a180e99f032f25dbb2a1e7f6dfb31efc81957a1cf3b8a8a"
    sha256 cellar: :any,                 big_sur:        "82a21cdd3acd75fd1a180e99f032f25dbb2a1e7f6dfb31efc81957a1cf3b8a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebcb8792d14d490331f3863a25a4bf8dba84122551a6a26573d6217188aa4442"
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