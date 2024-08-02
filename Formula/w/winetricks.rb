class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https:github.comWinetrickswinetricks"
  url "https:github.comWinetrickswinetricksarchiverefstags20240105.tar.gz"
  sha256 "e92929045cf9ffb1e8d16ef8fd971ea1cf63a28a73916b1951e9553c94482f61"
  license "LGPL-2.1-or-later"
  head "https:github.comWinetrickswinetricks.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d{6,8})$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05bbb807e30155dcb1aeabb9be0bc53090fa3c708f1a831bbd8dab7d99f0365f"
  end

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "srcwinetricks"
    man1.install "srcwinetricks.1"
  end

  test do
    system bin"winetricks", "--version"
  end
end