class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https:www.fltk.org"
  url "https:www.fltk.orgpubfltk1.3.10fltk-1.3.10-source.tar.gz"
  sha256 "c1c96d4f2ca7844f4b7945b4670aff2846f150cd5f3e23e3e4c70a61807108c7"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https:www.fltk.orgsoftware.php"
    regex(href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "54759e1f0e09059afe4336d8dd8c7553b2c3826fd7de66c68d646ad7de28845d"
    sha256 arm64_sonoma:  "f396bd099823600cb79495748dc245766495986e53ccc17c3f6f9f1e798c84cb"
    sha256 arm64_ventura: "78ffee8da5edf502295b918f039a2bd351621c43d700c5713f0c6b6b397973a2"
    sha256 sonoma:        "5862341ba160f98a461fa44f71975b4620e20513d7f91c92d10856a2e7d95e10"
    sha256 ventura:       "3655b8af66de20eab4e70ce5ff45941780fed5078d0610e45639c5e0922f4678"
    sha256 x86_64_linux:  "ec631462814cb6bec51b83dc38663df566c09ec4cdb307c6af1976f197c4b2b1"
  end

  head do
    url "https:github.comfltkfltk.git", branch: "master"
    depends_on "cmake" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    if build.head?
      args = std_cmake_args

      # Don't build docs  require doxygen
      args << "-DOPTION_BUILD_HTML_DOCUMENTATION=OFF"
      args << "-DOPTION_BUILD_PDF_DOCUMENTATION=OFF"

      # Don't build tests
      args << "-DFLTK_BUILD_TEST=OFF"

      # Build both shared & static libs
      args << "-DOPTION_BUILD_SHARED_LIBS=ON"

      system "cmake", ".", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    else
      system ".configure", "--prefix=#{prefix}",
                            "--enable-threads",
                            "--enable-shared"
      system "make", "install"
    end
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <FLFl.H>
      #include <FLFl_Window.H>
      #include <FLFl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system ".test"
  end
end