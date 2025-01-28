class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.5.1.zip"
  sha256 "a62794ea220914c236bd5d75896e4743dd471f58e4535e56195e2b8c80891411"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813ae205588aca64775a986bc2e18ba3a2f6452eb0a102ea5fe7c4a25e02b415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813ae205588aca64775a986bc2e18ba3a2f6452eb0a102ea5fe7c4a25e02b415"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "813ae205588aca64775a986bc2e18ba3a2f6452eb0a102ea5fe7c4a25e02b415"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3730bb9c6f04c5a747bf0502225854d824fb587a1439619c94b8bdd7d600185"
    sha256 cellar: :any_skip_relocation, ventura:       "d3730bb9c6f04c5a747bf0502225854d824fb587a1439619c94b8bdd7d600185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813ae205588aca64775a986bc2e18ba3a2f6452eb0a102ea5fe7c4a25e02b415"
  end

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