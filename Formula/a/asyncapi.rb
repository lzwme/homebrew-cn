require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.27.tgz"
  sha256 "a96719ff81f1229434d104f9bc797c669e0df560858fd358a4ef60ee88a47db2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a970ad8668e167f5a8aa58224dd8c63ded4a465f79c097e26a968a6b1019d0ab"
    sha256 cellar: :any,                 arm64_ventura:  "a970ad8668e167f5a8aa58224dd8c63ded4a465f79c097e26a968a6b1019d0ab"
    sha256 cellar: :any,                 arm64_monterey: "a970ad8668e167f5a8aa58224dd8c63ded4a465f79c097e26a968a6b1019d0ab"
    sha256 cellar: :any,                 sonoma:         "59c07be80e8b8807c0d59f5f2e3a56f56fdad511f88d8e79fca7c1719c45ab38"
    sha256 cellar: :any,                 ventura:        "59c07be80e8b8807c0d59f5f2e3a56f56fdad511f88d8e79fca7c1719c45ab38"
    sha256 cellar: :any,                 monterey:       "59c07be80e8b8807c0d59f5f2e3a56f56fdad511f88d8e79fca7c1719c45ab38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5816e4a65128a3b3c835a188d667771ec1c325a71b7b8bbf0b2bc4c389499500"
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