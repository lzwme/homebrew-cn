class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "https://www.gcd.org/sengoku/stone/"
  url "https://www.gcd.org/sengoku/stone/stone-2.4.tar.gz"
  sha256 "d5dc1af6ec5da503f2a40b3df3fe19a8fbf9d3ce696b8f46f4d53d2ac8d8eb6f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?stone[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ea5e1f4e87879d1281b96a0ee7950c74e639429d622fe4e4ecfa2c2155ddc051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8db3b91a892716e56362887cdc17006d43abdb00f9897be80c1a06953cbed0ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7a8b20854a50d343960a965e340d0178fd82728e7c74025146b2ac053b24a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4274010ee7d7f736080d17b23ee12250fc7f68a530c9149a0a625922a9db1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a2008041ad4e5e76fe87a4218d4c21e5b1a2cea828aa97b9e9e5b6c6ecc882"
    sha256 cellar: :any_skip_relocation, sonoma:         "10a43ae132027d4493cde68c07c224bf59869c626b3f9d2f1f5583a16486acdf"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a0ba71f94f62594fe4e859a9be7b4616f8984410f7de532112f8c7f5566c97"
    sha256 cellar: :any_skip_relocation, monterey:       "dc89da0846364ce236eed2a2cfe0eb39abd9dc71f42f3b357d6a5709efb025d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f943cab7f931ae2b7c124a83b63150b9c3b75090eb63353fbe0732792b97a0bf"
    sha256 cellar: :any_skip_relocation, catalina:       "cadf40dd1d8aa5de47b9d3d3baa5bbc22fc5a8a50abe688e77520b035369f492"
    sha256 cellar: :any_skip_relocation, mojave:         "13be210aea90ed4b9067afcf0dcad8e54494c0f262aa94fb51f926f7a46b8e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d7847a7917f3d83398ed86e5889bc83306bb80e73734bd1157aa72856b498f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1986132ca2eabd91ea5b1193fefabc4f5af2253df1b4e720df4ddf4cddf433a0"
  end

  def install
    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    system "make", os
    bin.install "stone"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stone -h 2>&1", 1)
  end
end