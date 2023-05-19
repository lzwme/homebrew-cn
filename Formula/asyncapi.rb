require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.7.tgz"
  sha256 "68eb529788ce6d21bbbaebf8696d898f0b8263614527e7235d3ac5710c9cd8d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d39076d35ec17e3e6e3655c34a8f6dd4af28560b1d8f9f49c992385c14cdffb2"
    sha256 cellar: :any,                 arm64_monterey: "d39076d35ec17e3e6e3655c34a8f6dd4af28560b1d8f9f49c992385c14cdffb2"
    sha256 cellar: :any,                 arm64_big_sur:  "d39076d35ec17e3e6e3655c34a8f6dd4af28560b1d8f9f49c992385c14cdffb2"
    sha256 cellar: :any,                 ventura:        "4297d9900ff5d5a19d9590e21749c3afc932fb2aeb24cdc81ad551c87a714227"
    sha256 cellar: :any,                 monterey:       "4297d9900ff5d5a19d9590e21749c3afc932fb2aeb24cdc81ad551c87a714227"
    sha256 cellar: :any,                 big_sur:        "4297d9900ff5d5a19d9590e21749c3afc932fb2aeb24cdc81ad551c87a714227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f411f957a4fad826eafdd8ad056d526fd66a93c902318644737ed84b3618db7"
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