require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.5.tgz"
  sha256 "11bed48ae871f7fc3c3dd08eafec13c2334e94c2d19b77fa007893a4c4b98241"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad1f56e81826b09344e56d6bff1f6ff04eb2f9529689960df4e190a9ccbdfd67"
    sha256 cellar: :any,                 arm64_monterey: "ad1f56e81826b09344e56d6bff1f6ff04eb2f9529689960df4e190a9ccbdfd67"
    sha256 cellar: :any,                 arm64_big_sur:  "ad1f56e81826b09344e56d6bff1f6ff04eb2f9529689960df4e190a9ccbdfd67"
    sha256 cellar: :any,                 ventura:        "3fde2e462efaf4c738f67078c4b0f65f8a6e27b8b22f207f1be686c60d08f10e"
    sha256 cellar: :any,                 monterey:       "3fde2e462efaf4c738f67078c4b0f65f8a6e27b8b22f207f1be686c60d08f10e"
    sha256 cellar: :any,                 big_sur:        "3fde2e462efaf4c738f67078c4b0f65f8a6e27b8b22f207f1be686c60d08f10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0534466b1d89db2681f0add17e03460539255eae363e8493702076017df0e392"
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