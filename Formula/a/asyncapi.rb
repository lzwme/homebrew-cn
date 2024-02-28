require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.16.tgz"
  sha256 "cb3e883deed1a4d7ec1325a61515a88000a86781249ea2d6fee81b72775bf4c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c70eefa466b85deba535df5f7a719bbc48169f2bd79e21e630981add2d14751b"
    sha256 cellar: :any,                 arm64_ventura:  "c70eefa466b85deba535df5f7a719bbc48169f2bd79e21e630981add2d14751b"
    sha256 cellar: :any,                 arm64_monterey: "c70eefa466b85deba535df5f7a719bbc48169f2bd79e21e630981add2d14751b"
    sha256 cellar: :any,                 sonoma:         "1b69e1aec8986aff9479df5c76a3dac65953e0c31c818839374437fcd88540db"
    sha256 cellar: :any,                 ventura:        "1b69e1aec8986aff9479df5c76a3dac65953e0c31c818839374437fcd88540db"
    sha256 cellar: :any,                 monterey:       "1b69e1aec8986aff9479df5c76a3dac65953e0c31c818839374437fcd88540db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9759475fe7ee55a04224c033b1e807afd773ae7843889688d624c7df1be85cce"
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