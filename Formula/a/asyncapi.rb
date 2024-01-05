require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.32.tgz"
  sha256 "ba62ca1d6942408586c55c48391f157b7bde92390c4b3d166d3e17b342ee8f5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df05e09fb2501301b8c966fdd62bc258305f1a0ba56e72bef4ce4d3c9c329c40"
    sha256 cellar: :any,                 arm64_ventura:  "df05e09fb2501301b8c966fdd62bc258305f1a0ba56e72bef4ce4d3c9c329c40"
    sha256 cellar: :any,                 arm64_monterey: "df05e09fb2501301b8c966fdd62bc258305f1a0ba56e72bef4ce4d3c9c329c40"
    sha256 cellar: :any,                 sonoma:         "4554ae54bca19793de6ac7f88621ec9d904d999dd339b6085d72245a7535e409"
    sha256 cellar: :any,                 ventura:        "4554ae54bca19793de6ac7f88621ec9d904d999dd339b6085d72245a7535e409"
    sha256 cellar: :any,                 monterey:       "4554ae54bca19793de6ac7f88621ec9d904d999dd339b6085d72245a7535e409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d748659b64795b31b435c561eedb7f2ae45bb012916083c4b83dd6c59ea682"
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