require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.55.0.tgz"
  sha256 "c70407be69a525c089b5f957c9ba818f98f5b737c1c3caafe90387af06269678"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb23cc5652ff2821c139cd98f6f12b25c546f29617bad4315d61b3d22145d758"
    sha256 cellar: :any,                 arm64_monterey: "cb23cc5652ff2821c139cd98f6f12b25c546f29617bad4315d61b3d22145d758"
    sha256 cellar: :any,                 arm64_big_sur:  "cb23cc5652ff2821c139cd98f6f12b25c546f29617bad4315d61b3d22145d758"
    sha256 cellar: :any,                 ventura:        "d1046a1ea0e5773a718b8826617621c457b595e015ef3688d9fb51fc5be11525"
    sha256 cellar: :any,                 monterey:       "d1046a1ea0e5773a718b8826617621c457b595e015ef3688d9fb51fc5be11525"
    sha256 cellar: :any,                 big_sur:        "d1046a1ea0e5773a718b8826617621c457b595e015ef3688d9fb51fc5be11525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087736c9bd1760381c50016eb579a9fa7482b955a66bc3b230373d92d8712d7b"
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