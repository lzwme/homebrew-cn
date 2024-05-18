require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.15.0.tgz"
  sha256 "556c61d05bce052c96667d904a819cfe845d0691f1904d323651a5f9e6e95765"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "809d304c94033965030dfdc06ea839831b6b9a0c3125999d289c884982df4fee"
    sha256 cellar: :any,                 arm64_ventura:  "aa5c695768f394f4fad8e796333a50616860b4536a7300608a5dc2a3118de631"
    sha256 cellar: :any,                 arm64_monterey: "d60c5012106df750a09e79055d4e10c9bbb89690906e7916df023a1d4cf3e8d1"
    sha256 cellar: :any,                 sonoma:         "8a8d8b5056bec555c350f2794619449fdde44694e70a73f686608eeaa19d3860"
    sha256 cellar: :any,                 ventura:        "8a90d137f7d30bfdb223d2d045e4654bc772fd0b4e1d1075b2d14f566a54a78b"
    sha256 cellar: :any,                 monterey:       "69ddf48b7da990ea036792d6ea3eceb33213e7b0f408ee128d79808c94f49e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85771e803f941469e55b1d3e5f12cc5ed0cfba8af0cc9e9deb25d8669e50b03"
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