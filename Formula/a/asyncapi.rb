require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.4.tgz"
  sha256 "6203b944b604bcf6e8d5c2e99c088e2aa8a42df4da778863a94fdc4cbb13a0c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd21e2aa2630a70f3bab47700837854ecac51e541f8b054ddb6a1e1c106ccbae"
    sha256 cellar: :any,                 arm64_ventura:  "fd21e2aa2630a70f3bab47700837854ecac51e541f8b054ddb6a1e1c106ccbae"
    sha256 cellar: :any,                 arm64_monterey: "fd21e2aa2630a70f3bab47700837854ecac51e541f8b054ddb6a1e1c106ccbae"
    sha256 cellar: :any,                 sonoma:         "7847043033b87a4f0b3582be74ede609c9c5675fdfe27348ab03083871f7cd19"
    sha256 cellar: :any,                 ventura:        "7847043033b87a4f0b3582be74ede609c9c5675fdfe27348ab03083871f7cd19"
    sha256 cellar: :any,                 monterey:       "7847043033b87a4f0b3582be74ede609c9c5675fdfe27348ab03083871f7cd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2661f746aa34d909bbb83098bd2c7e3dbad9707251cb58543fa92bd55b0987b"
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