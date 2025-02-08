class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https:github.comthomasschaferscooter"
  url "https:github.comthomasschaferscooterarchiverefstagsv0.2.3.tar.gz"
  sha256 "071966e1a67179396f30d51c39db391a04f9d067034410ec5584bff64f5ae8b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef1dad028a918082eb6e0ef264960c7a02edd2c52ad422ab652ffbebcf2f85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797de09406f50842d303b40a2f00281ca79a46f8d10e8100cc4a8f0eb2146df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ef4957e5d4c8936bb9ee38ff0bb12e653ac23bbb4f160bc43fb172236432f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a726ec67e832cb5c9343952c4649e0272e60b0ecc2c9c935e28075bcb3dae92"
    sha256 cellar: :any_skip_relocation, ventura:       "9b4f5c84dbe4660f6421a37dc39eac5e0b7f83c399ccf83333f6bc8737d7db3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "713e9be8f35857fe3ddf5fbb82d3b3d319d06b7d018b2b5caa014edad09b8bde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}scooter -h")
  end
end