require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.4.4.tgz"
  sha256 "51d94f2dbbbeaa83b6a8dfd0c734ebd7c8dfb798246f4bf4650712aea03de5a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b7964182d25bb820fbb59663658423f71236040fc99d540673a835f66705331"
    sha256 cellar: :any,                 arm64_ventura:  "2b7964182d25bb820fbb59663658423f71236040fc99d540673a835f66705331"
    sha256 cellar: :any,                 arm64_monterey: "2b7964182d25bb820fbb59663658423f71236040fc99d540673a835f66705331"
    sha256 cellar: :any,                 sonoma:         "7396cb2a245482961ca9664b2751cf91b5c6790f62be1477f00438979024520e"
    sha256 cellar: :any,                 ventura:        "7396cb2a245482961ca9664b2751cf91b5c6790f62be1477f00438979024520e"
    sha256 cellar: :any,                 monterey:       "7396cb2a245482961ca9664b2751cf91b5c6790f62be1477f00438979024520e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8fe01fd5d938802704cb79f8a9d979fd091406fb8c13c043cbb5f4d55551b3"
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