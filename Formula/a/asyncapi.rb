class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.3.11.tgz"
  sha256 "e6b152ad0064b00ed4689ad010f6734d57f45fd4273b28e4d6fd3ea0a7fa5c7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1229264bf993f5f0212d9a01764c69c9ca8a72d4d33c9df7f935fe01e6fcc732"
    sha256 cellar: :any,                 arm64_ventura:  "1229264bf993f5f0212d9a01764c69c9ca8a72d4d33c9df7f935fe01e6fcc732"
    sha256 cellar: :any,                 arm64_monterey: "1229264bf993f5f0212d9a01764c69c9ca8a72d4d33c9df7f935fe01e6fcc732"
    sha256 cellar: :any,                 sonoma:         "8421d854099dcfaf2a97cf0fa7f48b115cea75649593ac8ca9787946fb4eebbc"
    sha256 cellar: :any,                 ventura:        "8421d854099dcfaf2a97cf0fa7f48b115cea75649593ac8ca9787946fb4eebbc"
    sha256 cellar: :any,                 monterey:       "8421d854099dcfaf2a97cf0fa7f48b115cea75649593ac8ca9787946fb4eebbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728e6a024ee6b6f33774ae44c49789c4a1251158310842069bc1b7d6b77f4800"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end