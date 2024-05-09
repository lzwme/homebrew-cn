require "languagenode"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https:github.comsvgsvgo"
  url "https:github.comsvgsvgoarchiverefstagsv3.3.1.tar.gz"
  sha256 "a601a016d7a97fe1348e59944f4d00fe166221e252bffc5145c7258ece21c6ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74cc893a0095035a53af50c6e7268c880cdbfefa651bbc91fd1e094e187c9f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b86716f33ae49a23453d75bd2cf883216779f9e1602268c1d0c50665d77f7336"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "358b2fd020df2d8737f0410d8e7637af3a179282c55fc48433e249db595c75c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "87053b8abbf5605294caf297b9809cc3d7fc9e3c249ec950af364767683f7020"
    sha256 cellar: :any_skip_relocation, ventura:        "1cc0dc1086aae1d249a0e610f06fcea34ced9de2645e8cb62272c822708af150"
    sha256 cellar: :any_skip_relocation, monterey:       "be3105cd3c4850f79d2c31e4472c2dcce9148b77916df27be77aaa32cfaaac3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c153cb0a087440fa7db6b0d4590ddab2bd93f21e958999b4d552db8b1339c36"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(^<svg , (testpath"test.min.svg").read)
  end
end