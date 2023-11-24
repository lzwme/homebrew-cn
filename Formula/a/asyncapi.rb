require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.3.tgz"
  sha256 "4e55ea51a38fd76fe3748a9585de97f0e1fb43145d70efae054798faae4317f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97b6c26652af46dfd7b86953d213d416eabcfb8672b7d9f9e8dede8773c4eda0"
    sha256 cellar: :any,                 arm64_ventura:  "97b6c26652af46dfd7b86953d213d416eabcfb8672b7d9f9e8dede8773c4eda0"
    sha256 cellar: :any,                 arm64_monterey: "97b6c26652af46dfd7b86953d213d416eabcfb8672b7d9f9e8dede8773c4eda0"
    sha256 cellar: :any,                 sonoma:         "35a99efb8488780a4a3045d4e8c64a9d47bbf5630ee8c2c5d848cf8813232ffd"
    sha256 cellar: :any,                 ventura:        "35a99efb8488780a4a3045d4e8c64a9d47bbf5630ee8c2c5d848cf8813232ffd"
    sha256 cellar: :any,                 monterey:       "35a99efb8488780a4a3045d4e8c64a9d47bbf5630ee8c2c5d848cf8813232ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e106f6fc7d9bdd9823bc7528c89166a5c851e06628f71f42662806c019f65588"
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