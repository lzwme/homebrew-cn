require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.4.0.tgz"
  sha256 "562b61f311862df5eea5a0c4661dd00ea97ea6d56cfeef8f832a17aeefb2b055"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b4176aa3819679184c8e2337b73b612fb4841c19f0c02c4fa42b3fd5530baea"
    sha256 cellar: :any,                 arm64_ventura:  "9b4176aa3819679184c8e2337b73b612fb4841c19f0c02c4fa42b3fd5530baea"
    sha256 cellar: :any,                 arm64_monterey: "9b4176aa3819679184c8e2337b73b612fb4841c19f0c02c4fa42b3fd5530baea"
    sha256 cellar: :any,                 sonoma:         "186b79c74ff3ac58b5b6d9264f54cce3be3751462aea68c3996b1776ad29ebe8"
    sha256 cellar: :any,                 ventura:        "186b79c74ff3ac58b5b6d9264f54cce3be3751462aea68c3996b1776ad29ebe8"
    sha256 cellar: :any,                 monterey:       "186b79c74ff3ac58b5b6d9264f54cce3be3751462aea68c3996b1776ad29ebe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbda45e507e44d384b6e6ba4e2abe7b8140b421b9d6a91eaa107bf8f06c9b351"
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