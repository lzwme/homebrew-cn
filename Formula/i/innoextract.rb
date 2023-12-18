class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https:constexpr.orginnoextract"
  url "https:constexpr.orginnoextractfilesinnoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 6
  head "https:github.comdscharrerinnoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2123d53eec27b2f68656f72df70ca1625d0579a2d2582ef6b66664f31ac90305"
    sha256 cellar: :any,                 arm64_ventura:  "5d3be8341c3452bc90f94b9d9e6ba45e5c4d6708d7b3c3cca81ea5ca56f69b82"
    sha256 cellar: :any,                 arm64_monterey: "7ebe336dbca7d52211b6dcdf183bb9c241bab7efe28edc6cfa3c4fbe6ee1c365"
    sha256 cellar: :any,                 sonoma:         "a1f1f376f09ba0910e014ab9548c98b0083502aa7fa2ec7cd0f7a91f447f413d"
    sha256 cellar: :any,                 ventura:        "5438b13e79c2f9d37d0af1661d6f2c14fcaf0b976731bf74a8fecd9e72830cfd"
    sha256 cellar: :any,                 monterey:       "222d556a09ccc53fa4d8e69060825c85cac9cde2c64bb6d089c7f0d439dbf0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd41318171b61adac1811c3f06bc4ce8e8fedcc5c61d51723b46d78b42d603a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}innoextract", "--version"
  end
end