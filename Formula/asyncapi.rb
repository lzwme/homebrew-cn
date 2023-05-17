require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.6.tgz"
  sha256 "a9f766d6e54eef48c76ff24313893498e7f1252288124d388ad9a0f9f266d18e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b9aa53168def0afc399a841852d74a144c8fd6f455921ecf4c5ae27d8041791"
    sha256 cellar: :any,                 arm64_monterey: "6b9aa53168def0afc399a841852d74a144c8fd6f455921ecf4c5ae27d8041791"
    sha256 cellar: :any,                 arm64_big_sur:  "6b9aa53168def0afc399a841852d74a144c8fd6f455921ecf4c5ae27d8041791"
    sha256 cellar: :any,                 ventura:        "4b030e6b603e29172b4ee6b8928acf790de4dbf65192ad6120dd098489d50cc2"
    sha256 cellar: :any,                 monterey:       "4b030e6b603e29172b4ee6b8928acf790de4dbf65192ad6120dd098489d50cc2"
    sha256 cellar: :any,                 big_sur:        "4b030e6b603e29172b4ee6b8928acf790de4dbf65192ad6120dd098489d50cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776830eb5cbe491f24c3e12046006467ed8728730ced45837141fa55fe0a3008"
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