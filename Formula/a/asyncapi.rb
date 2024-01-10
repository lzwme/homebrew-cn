require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.34.tgz"
  sha256 "ade3b81987c92e5efc2ec66de083c44de0cf58ba7e47012cce7c70b33af79276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b372a5da68d55701ab1e5a892bc13a723bb5cb16da2fe9ad81c301c71efde17a"
    sha256 cellar: :any,                 arm64_ventura:  "b372a5da68d55701ab1e5a892bc13a723bb5cb16da2fe9ad81c301c71efde17a"
    sha256 cellar: :any,                 arm64_monterey: "b372a5da68d55701ab1e5a892bc13a723bb5cb16da2fe9ad81c301c71efde17a"
    sha256 cellar: :any,                 sonoma:         "ae51744d449c62968ec3661b705bb19d6056285cfdca541b68dbcd8de9ff69e4"
    sha256 cellar: :any,                 ventura:        "ae51744d449c62968ec3661b705bb19d6056285cfdca541b68dbcd8de9ff69e4"
    sha256 cellar: :any,                 monterey:       "ae51744d449c62968ec3661b705bb19d6056285cfdca541b68dbcd8de9ff69e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0c49290ce067bcec2d8e7bc27e7869b0b3fac3eb581bf6a923e7eff9ecd583"
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