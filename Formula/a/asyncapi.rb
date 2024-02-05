require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.2.tgz"
  sha256 "5d30c53d72f545fc97df95df9b26bb220f3f1b403f8090b8ae47a19c580f8afe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a46b03328e5ee622cfbb90a38515ba2fec0a4ea70bcd2bd259cf929547687f6"
    sha256 cellar: :any,                 arm64_ventura:  "2a46b03328e5ee622cfbb90a38515ba2fec0a4ea70bcd2bd259cf929547687f6"
    sha256 cellar: :any,                 arm64_monterey: "2a46b03328e5ee622cfbb90a38515ba2fec0a4ea70bcd2bd259cf929547687f6"
    sha256 cellar: :any,                 sonoma:         "85724d836d0bdc0e2858a8c8313237450639f87fd29168eeb61d1cb14e6fbc27"
    sha256 cellar: :any,                 ventura:        "85724d836d0bdc0e2858a8c8313237450639f87fd29168eeb61d1cb14e6fbc27"
    sha256 cellar: :any,                 monterey:       "85724d836d0bdc0e2858a8c8313237450639f87fd29168eeb61d1cb14e6fbc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96472c597a078ede630e371e84384966b6e161dff3bb63066fb6880dc81492c8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    (node_modules"@swccore-linux-x64-muslswc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end