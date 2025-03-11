class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https:libical.github.iolibical"
  url "https:github.comlibicallibicalreleasesdownloadv3.0.20libical-3.0.20.tar.gz"
  sha256 "e73de92f5a6ce84c1b00306446b290a2b08cdf0a80988eca0a2c9d5c3510b4c2"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35480b405819775d6e24f123e979102e7de19ffea229979a661ff54ed12e84bc"
    sha256 cellar: :any,                 arm64_sonoma:  "17aaa90443b2d8f8020deb16fdc9c1e9462e8a672aa25ff8035cafbf44b26417"
    sha256 cellar: :any,                 arm64_ventura: "a24c31e2cb01569dfb136fd87a609641b6d777161d45f5b7102c84ef6be5e5f7"
    sha256 cellar: :any,                 sonoma:        "bd8acae626a452145ba4fca7377c7debdd34936b6facfd590a39503cdcfba675"
    sha256 cellar: :any,                 ventura:       "f14953f23eda899e6a93307ed876024abb032fef5ce485bfd6a1e6935774d830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68ee179a8806178f0498671136b1e7ee5d317ec0be41dbdb4255db6714f4eb3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@76"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

  def install
    args = %W[
      -DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND
      -DENABLE_GTK_DOC=OFF
      -DSHARED_ONLY=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-gliblibical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}glib-2.0",
                   "-I#{Formula["glib"].opt_lib}glib-2.0include"
    system ".test"
  end
end