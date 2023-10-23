class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://ghproxy.com/https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 7
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "15aa656e045954f1c843adfdcf67fb48ca3ba1bcfc05bc2a98e2a0d3b18512dc"
    sha256 cellar: :any,                 arm64_ventura:  "55d77e055d62389e516eec15f0eccba903bdcd12bd9d1814c1683f6eec865044"
    sha256 cellar: :any,                 arm64_monterey: "450a588e8483de8ef7995888fc41f49927ec8702dd65183949184f8a7e5dd0e4"
    sha256 cellar: :any,                 sonoma:         "b562c6c1f54045dbf6aaa20e0132d181d567eb9f4317fe68bbb05cc21b29d9aa"
    sha256 cellar: :any,                 ventura:        "89aa983d8b0dfa007392027d80f3a358a0e6205cc596d817983e50c5bef85cb2"
    sha256 cellar: :any,                 monterey:       "7deaeeaf0cc73e1b657c527fa4e658d82942816fe64e676f69856308caaa7d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baaa30ccc9d1bf80a9cf686f1dcd35daf6dd7db3e3df090c34238bcd0eeaca59"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "libxml2"

  def install
    # Remove bundled libraries to avoid fallback
    (buildpath/"dom/external-libs").rmtree

    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output("./test").chomp
  end
end