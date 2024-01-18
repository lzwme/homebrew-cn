class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "https://sfcgal.gitlab.io/SFCGAL/"
  url "https://gitlab.com/sfcgal/SFCGAL/-/archive/v1.5.1/SFCGAL-v1.5.1.tar.gz"
  sha256 "ea5d1662fada7de715ad564dc810c3059024ed81ae393f5352489f706fdfa3b1"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f1c614cd999a7295cb88640c695d8eaf83517f79dce924629a85fd47c827f76"
    sha256 cellar: :any,                 arm64_ventura:  "3d2d521b724bec59ffed0036514c72554d828717863ff97fbd084a911d711188"
    sha256 cellar: :any,                 arm64_monterey: "58fd30ef73d9392a9c607d3fde7e3b4ecc6df2549ccbba65231865e86b3e8d3b"
    sha256 cellar: :any,                 sonoma:         "3ec852763d9340d72cb12bede2d437a15f0ceff4cdbbf81f25a6f6c461e3b141"
    sha256 cellar: :any,                 ventura:        "b37a971fe87d1c73c7bbd8dfff0da8dadd070c00caa5774bc0cc61dd873122e0"
    sha256 cellar: :any,                 monterey:       "c2d59ba70d6043c99589b9d91c40b8bea011bea5b8013fc0102fa331fc9c693a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43538286e5e61e1ce3d55b7e15dca68fe8b011cfbb4ca377f7a6091514487d8a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # error: array must be initialized with a brace-enclosed initializer
  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end