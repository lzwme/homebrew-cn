require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.6.tgz"
  sha256 "d87224d329c9095aacfe46938be8019ca900cf28be6245e2e096c1700592f256"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c3fb33d77f7422f1e4381a7907b49604c97e93eb13a29f77699eb2218d765e6f"
    sha256 cellar: :any,                 arm64_ventura:  "c3fb33d77f7422f1e4381a7907b49604c97e93eb13a29f77699eb2218d765e6f"
    sha256 cellar: :any,                 arm64_monterey: "c3fb33d77f7422f1e4381a7907b49604c97e93eb13a29f77699eb2218d765e6f"
    sha256 cellar: :any,                 sonoma:         "bd63444cebc1e3885731658e93f1b5bbceac236ad2498282e9f153d05247503a"
    sha256 cellar: :any,                 ventura:        "bd63444cebc1e3885731658e93f1b5bbceac236ad2498282e9f153d05247503a"
    sha256 cellar: :any,                 monterey:       "bd63444cebc1e3885731658e93f1b5bbceac236ad2498282e9f153d05247503a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41d3fd13540ecc76e61b5b52ce660062ffd5fb859ea73e2ae2d133c0242758d"
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