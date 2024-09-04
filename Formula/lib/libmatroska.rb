class Libmatroska < Formula
  desc "Extensible, open standard container format for audiovideo"
  homepage "https:www.matroska.org"
  url "https:dl.matroska.orgdownloadslibmatroskalibmatroska-1.7.1.tar.xz"
  sha256 "572a3033b8d93d48a6a858e514abce4b2f7a946fe1f02cbfeca39bfd703018b3"
  license "LGPL-2.1-or-later"
  head "https:github.comMatroska-Orglibmatroska.git", branch: "master"

  livecheck do
    url "https:dl.matroska.orgdownloadslibmatroska"
    regex(href=.*?libmatroska[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "297b69d493d6b09441e452745dee037ed4c211642a30ab4acfb3f229423e9995"
    sha256 cellar: :any,                 arm64_ventura:  "029766b0222c5d9a72a3cc63410c18a1d6b485243bdb4430f42e515ab24e18dd"
    sha256 cellar: :any,                 arm64_monterey: "7648ded88703290bc998629288b942f2ac26585c9945d1443d14fe454654e306"
    sha256 cellar: :any,                 arm64_big_sur:  "bb9b3e6993c88b36acddbce97f6085f6785cd57812bece2b37fb56360054010a"
    sha256 cellar: :any,                 sonoma:         "4abfa8d4c378d3d1a635d47c7520590fa33366bc8d2f8d5feb00fbe960d1c5b1"
    sha256 cellar: :any,                 ventura:        "7e0cfe0a5bc3503bb309dce7ba7f78a75259daff686a387b9413c7db9580ed77"
    sha256 cellar: :any,                 monterey:       "e2282bbaca89473b275731eee79be5a8ac1f5402c9603be4a0545c65b2d929d5"
    sha256 cellar: :any,                 big_sur:        "1b3b6df53eb2070d742dec37fcf4f2ebf81728bfe1c64e82ac4a78bb58c80288"
    sha256 cellar: :any,                 catalina:       "3a4ca07a150e0719bc8bacedced44c6cec1116e0050095e8c669d37a4d47eb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b54ecbcbef470960678043620106e649fb75f05ba3b26ef6d24aad0476a9fe"
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end