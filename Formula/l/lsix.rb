class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https:github.comhackerb9lsix"
  url "https:github.comhackerb9lsixarchiverefstags1.9.tar.gz"
  sha256 "e1b33cf97b83c96d57de3c593656a11236df394d739a8aa755e9e97f74d8e960"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6933808648e9cbccc4289852c29d528d8db07c0b43591e3d2fc6546a0ba2f7f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6933808648e9cbccc4289852c29d528d8db07c0b43591e3d2fc6546a0ba2f7f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6933808648e9cbccc4289852c29d528d8db07c0b43591e3d2fc6546a0ba2f7f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6933808648e9cbccc4289852c29d528d8db07c0b43591e3d2fc6546a0ba2f7f9"
    sha256 cellar: :any_skip_relocation, ventura:        "6933808648e9cbccc4289852c29d528d8db07c0b43591e3d2fc6546a0ba2f7f9"
    sha256 cellar: :any_skip_relocation, monterey:       "6933808648e9cbccc4289852c29d528d8db07c0b43591e3d2fc6546a0ba2f7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3811ff3e34633b66d3f7592cbc227256edef0fd04ce57b033e8fa0ebd3ca58"
  end

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end