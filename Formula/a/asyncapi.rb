require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.33.tgz"
  sha256 "29f241944a8632552ec34a6a7f3bb9d1716f25f9ea01a04603b8b04497c8aebc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e479097f930b9decea37ddf5aeaa7165c33a014f7709211e8c6e67b33e64764"
    sha256 cellar: :any,                 arm64_ventura:  "2e479097f930b9decea37ddf5aeaa7165c33a014f7709211e8c6e67b33e64764"
    sha256 cellar: :any,                 arm64_monterey: "2e479097f930b9decea37ddf5aeaa7165c33a014f7709211e8c6e67b33e64764"
    sha256 cellar: :any,                 sonoma:         "425e1b24340623ea7df8841c5066bb027a4d1ecefce2227d9ca1e70592b7535a"
    sha256 cellar: :any,                 ventura:        "425e1b24340623ea7df8841c5066bb027a4d1ecefce2227d9ca1e70592b7535a"
    sha256 cellar: :any,                 monterey:       "425e1b24340623ea7df8841c5066bb027a4d1ecefce2227d9ca1e70592b7535a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9318100d3ec19d1d03127fe134bb7c4e40fcfddb7e5e20d629776bacdd6b69ab"
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