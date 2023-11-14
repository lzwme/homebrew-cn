require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.60.1.tgz"
  sha256 "9add3badfa043c59053586e2acfa42ba11310dcfeb2e1a4f078542d4e9cf8ea5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "056053bb7e07c4af6d4a037b8afc348fb5297a3e03eb9027d15d6792f6d94a95"
    sha256 cellar: :any,                 arm64_ventura:  "056053bb7e07c4af6d4a037b8afc348fb5297a3e03eb9027d15d6792f6d94a95"
    sha256 cellar: :any,                 arm64_monterey: "056053bb7e07c4af6d4a037b8afc348fb5297a3e03eb9027d15d6792f6d94a95"
    sha256 cellar: :any,                 sonoma:         "3a025ceed1d016f4aa2ef5a28df3515f7296190e087a7ea570e46eb94254153f"
    sha256 cellar: :any,                 ventura:        "3a025ceed1d016f4aa2ef5a28df3515f7296190e087a7ea570e46eb94254153f"
    sha256 cellar: :any,                 monterey:       "3a025ceed1d016f4aa2ef5a28df3515f7296190e087a7ea570e46eb94254153f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0136f2a07d3e4db76f4370991538e6a59462c3f450ea64e0741063ec0630d8b8"
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