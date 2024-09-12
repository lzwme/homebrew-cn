class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.4.2.zip"
  sha256 "118935d31b4db8d133bec8005277e195f8f6ff75889f2a83c6d2b873fd24bd3a"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "194a508f1b48c29b295b147a46381afadc2d3814c706b650ecc37eb35e25fa91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "194a508f1b48c29b295b147a46381afadc2d3814c706b650ecc37eb35e25fa91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "194a508f1b48c29b295b147a46381afadc2d3814c706b650ecc37eb35e25fa91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "194a508f1b48c29b295b147a46381afadc2d3814c706b650ecc37eb35e25fa91"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1d3db141503443987c8bfb1384975e579811a13d8240b4184ac5c344959cdbd"
    sha256 cellar: :any_skip_relocation, ventura:        "d1d3db141503443987c8bfb1384975e579811a13d8240b4184ac5c344959cdbd"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d3db141503443987c8bfb1384975e579811a13d8240b4184ac5c344959cdbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "194a508f1b48c29b295b147a46381afadc2d3814c706b650ecc37eb35e25fa91"
  end

  fails_with gcc: "5" # C++ 17 is required

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end