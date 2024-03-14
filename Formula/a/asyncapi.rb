require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.6.4.tgz"
  sha256 "574abfeb29857d47cf430638e1ea02a996faa4486fb524ba11eabcf7ba4969c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a256a15ff7ac703bf580ae5df4a6a59340ca4b45d9b2c1515257b4e0ab691ad"
    sha256 cellar: :any,                 arm64_ventura:  "0a256a15ff7ac703bf580ae5df4a6a59340ca4b45d9b2c1515257b4e0ab691ad"
    sha256 cellar: :any,                 arm64_monterey: "0a256a15ff7ac703bf580ae5df4a6a59340ca4b45d9b2c1515257b4e0ab691ad"
    sha256 cellar: :any,                 sonoma:         "4f887bf33b7fc2377e6d8e1a959e63536ab4e4fa984053a1996516ecd0f587d3"
    sha256 cellar: :any,                 ventura:        "4f887bf33b7fc2377e6d8e1a959e63536ab4e4fa984053a1996516ecd0f587d3"
    sha256 cellar: :any,                 monterey:       "4f887bf33b7fc2377e6d8e1a959e63536ab4e4fa984053a1996516ecd0f587d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00f6755e23ea91164eeb703dbb3b6c92fcbab9847f28380c97bd7300ead79dd"
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