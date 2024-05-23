require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.15.3.tgz"
  sha256 "0bd175e05f400fa1f17df8d5f960178214ed53327566b07b470a4d244599ef35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14f98f7793b304640f4cb7b25444b8b3f4d12063260309037bd9d4097dde0a9d"
    sha256 cellar: :any,                 arm64_ventura:  "e6d3d97bc55a3c29cea7a21e6242aac44c67a03c793d33d1d6500ae30711e902"
    sha256 cellar: :any,                 arm64_monterey: "b3be90439f52edb261ad193ffa16bee12485d64200d44760e39594104b1622d5"
    sha256 cellar: :any,                 sonoma:         "6a64850fe1834097e29ff4a8cb076d8cd84cd6a04b7078b766085b4ac4fa08dd"
    sha256 cellar: :any,                 ventura:        "fa11cb2f61a13eebffdeea7efa9b2b30b18e1a7058010462d1fd9d835dcdfb0e"
    sha256 cellar: :any,                 monterey:       "935c797c5eee411475cd644f7aab9ab0a371f527c041984d5365b24614fe680e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f6016b54c9589e6a7d4b0effa8b3fe8dffba997944e108409421a09738a806"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end