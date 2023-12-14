require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.19.tgz"
  sha256 "305efccd5a37016838ca6dc0fb59e3915402f3002f8d2935eeb138857443ce8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "502d4e9a7646c7cfa48e8db2e6ac5a77cc79706c8b67a1ea7379fbf917327fd5"
    sha256 cellar: :any,                 arm64_ventura:  "502d4e9a7646c7cfa48e8db2e6ac5a77cc79706c8b67a1ea7379fbf917327fd5"
    sha256 cellar: :any,                 arm64_monterey: "502d4e9a7646c7cfa48e8db2e6ac5a77cc79706c8b67a1ea7379fbf917327fd5"
    sha256 cellar: :any,                 sonoma:         "2cacbcdac281764166f6c8b8ad754e8a84535a864511c3b589ba263bfddac4d7"
    sha256 cellar: :any,                 ventura:        "2cacbcdac281764166f6c8b8ad754e8a84535a864511c3b589ba263bfddac4d7"
    sha256 cellar: :any,                 monterey:       "2cacbcdac281764166f6c8b8ad754e8a84535a864511c3b589ba263bfddac4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b96978d0568749e2ca8526a108778a913f86aece17c8f81d260ed0dd2a509e1"
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