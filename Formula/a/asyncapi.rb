require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.12.tgz"
  sha256 "3e345b2417c1b2e9f259d617b4e002580499176a401c2b162f662f9e072327c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7d75807d0e4de006827f35fb081c992f607c7fae15cfbb0146ed07a7b64b9ea"
    sha256 cellar: :any,                 arm64_ventura:  "c7d75807d0e4de006827f35fb081c992f607c7fae15cfbb0146ed07a7b64b9ea"
    sha256 cellar: :any,                 arm64_monterey: "c7d75807d0e4de006827f35fb081c992f607c7fae15cfbb0146ed07a7b64b9ea"
    sha256 cellar: :any,                 sonoma:         "ee153ea8f82f65e29ca9331b237949e4e27bb192f97388cdcacf63c8a6dd64cb"
    sha256 cellar: :any,                 ventura:        "ee153ea8f82f65e29ca9331b237949e4e27bb192f97388cdcacf63c8a6dd64cb"
    sha256 cellar: :any,                 monterey:       "ee153ea8f82f65e29ca9331b237949e4e27bb192f97388cdcacf63c8a6dd64cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ea02b5bb9d28386f3e84c5b8a2ebdf1f77d448c4c23e60f27d240da3686e58"
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