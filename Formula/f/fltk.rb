class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https:www.fltk.org"
  url "https:www.fltk.orgpubfltk1.4.0fltk-1.4.0-source.tar.gz"
  sha256 "59a977d58975071b04b0d2e9c176bdca805404161ab712605019a5f8ff3c3c53"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https:www.fltk.orgsoftware.php"
    regex(href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "5960232ae6391fa7d9ce9ef8e966a894155e0bf7153f6eae1e4e26609a035730"
    sha256 arm64_sonoma:  "8e0202d18c58a749eb407917a73c5974fce7c232baf8aaea57592c2d8f41383c"
    sha256 arm64_ventura: "4585a6b4f195847dd50530b06377c9970f7c55040334ff5367e5e02c1fd9c0f0"
    sha256 sonoma:        "bb977df395dbc40d100647cc9b49a5f63236a93be4abda4d66258c50db6d85db"
    sha256 ventura:       "6dbf3af209d938a5e315f822e70efef76863ab05c169db6e9a0b68de172e2916"
    sha256 x86_64_linux:  "b9f3ce48a2066a8acfa2dca7e757952bde3e6ad4408da9d1135c4cbcaf06654f"
  end

  head do
    url "https:github.comfltkfltk.git", branch: "master"
    depends_on "cmake" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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
      args = [
        # Don't build docs  require doxygen
        "-DOPTION_BUILD_HTML_DOCUMENTATION=OFF",
        "-DOPTION_BUILD_PDF_DOCUMENTATION=OFF",
        # Don't build tests
        "-DFLTK_BUILD_TEST=OFF",
        # Build both shared & static libs
        "-DOPTION_BUILD_SHARED_LIBS=ON",
      ]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      args = %w[
        --enable-threads
        --enable-shared
      ]
      system ".configure", *args, *std_configure_args
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