require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.56.3.tgz"
  sha256 "bfc375fa855a51f3d9014bdabec2633a4b7c59825bb3d3ed9a95447d0118df2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "939e67523aed2c788f503ea50e1d42277085812171b9170dd7015aadbf7f918b"
    sha256 cellar: :any,                 arm64_monterey: "939e67523aed2c788f503ea50e1d42277085812171b9170dd7015aadbf7f918b"
    sha256 cellar: :any,                 arm64_big_sur:  "939e67523aed2c788f503ea50e1d42277085812171b9170dd7015aadbf7f918b"
    sha256 cellar: :any,                 ventura:        "47c9e51d8dd809bb10bd3c9c3b6c532220f73486a140d346b2f934ba7846e000"
    sha256 cellar: :any,                 monterey:       "923957204718c9df6cbda708c6f4f56893b37248a274b2f6471fa82118b46cfe"
    sha256 cellar: :any,                 big_sur:        "923957204718c9df6cbda708c6f4f56893b37248a274b2f6471fa82118b46cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35b9f8620de733cb1b9d6d0fbf32db08c758864b8bf801b1273b62f7b07b368"
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