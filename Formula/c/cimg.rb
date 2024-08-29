class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.4.1.zip"
  sha256 "f64a69530664128278382454941b4d9bf8ba7f7f9520e9d22cd98dc535d7fb08"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fb31fcec578133ea9c91c0f9849a5fa5c6f7549c5d463078015ef9b1e2df310"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fb31fcec578133ea9c91c0f9849a5fa5c6f7549c5d463078015ef9b1e2df310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fb31fcec578133ea9c91c0f9849a5fa5c6f7549c5d463078015ef9b1e2df310"
    sha256 cellar: :any_skip_relocation, sonoma:         "3086d14557b85ca0f0096b4c2f59764cbe11beea6f6ed53209c1f530372abfe0"
    sha256 cellar: :any_skip_relocation, ventura:        "3086d14557b85ca0f0096b4c2f59764cbe11beea6f6ed53209c1f530372abfe0"
    sha256 cellar: :any_skip_relocation, monterey:       "3086d14557b85ca0f0096b4c2f59764cbe11beea6f6ed53209c1f530372abfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb31fcec578133ea9c91c0f9849a5fa5c6f7549c5d463078015ef9b1e2df310"
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