require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.59.0.tgz"
  sha256 "af13eff89f79969b66e09e30a06c71245ecbf75064cd75af8aa393c5917b7065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ebf355be12205637d009cb1b3d613806905758b2e692a62a9b31d4ad1f9855e"
    sha256 cellar: :any,                 arm64_ventura:  "3ebf355be12205637d009cb1b3d613806905758b2e692a62a9b31d4ad1f9855e"
    sha256 cellar: :any,                 arm64_monterey: "3ebf355be12205637d009cb1b3d613806905758b2e692a62a9b31d4ad1f9855e"
    sha256 cellar: :any,                 sonoma:         "70e9efaae0405dfc4d47e771466c1b08c9b6f3ed430641209cd2dee12168741a"
    sha256 cellar: :any,                 ventura:        "70e9efaae0405dfc4d47e771466c1b08c9b6f3ed430641209cd2dee12168741a"
    sha256 cellar: :any,                 monterey:       "70e9efaae0405dfc4d47e771466c1b08c9b6f3ed430641209cd2dee12168741a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af9bb111dfcd4f8c53a50311a5b6f712a031d88a8eb7c7a27a568f9ba89439c"
  end

  depends_on "node"

  def install
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