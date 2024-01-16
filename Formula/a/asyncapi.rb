require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.3.0.tgz"
  sha256 "6a67859b78a3eab62d81e1de54c5989ba892404645432db7c909c4aab5ab8dad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4087dfb18435c852c3ce664bda2582c0e913f93843c60cd9feee4d0cba46a72"
    sha256 cellar: :any,                 arm64_ventura:  "e4087dfb18435c852c3ce664bda2582c0e913f93843c60cd9feee4d0cba46a72"
    sha256 cellar: :any,                 arm64_monterey: "e4087dfb18435c852c3ce664bda2582c0e913f93843c60cd9feee4d0cba46a72"
    sha256 cellar: :any,                 sonoma:         "923c250e4baab318b5ab4c78d713a8e42b9978e5e36ec18e24303f99a452c712"
    sha256 cellar: :any,                 ventura:        "923c250e4baab318b5ab4c78d713a8e42b9978e5e36ec18e24303f99a452c712"
    sha256 cellar: :any,                 monterey:       "923c250e4baab318b5ab4c78d713a8e42b9978e5e36ec18e24303f99a452c712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1da919b80e94add020f9d6f660211c99686c87f8da5d33deaf00ad2775a71a"
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