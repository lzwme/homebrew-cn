class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://ghproxy.com/https://github.com/GPSBabel/gpsbabel/archive/refs/tags/gpsbabel_1_9_0.tar.gz"
  sha256 "7801d30553bbc25d0b0e8186f2f5a1ec41397e51a26b92cc8ad1aeaa77c9beb6"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^gpsbabel[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67f736d8b27fd6ed2273e0448d0984d1972e78daf10af9ffbd57f2e81a871050"
    sha256 cellar: :any,                 arm64_ventura:  "2ce694f25190c74129462218a6d8d3142fd12189196269bb9d2093d7e9e62020"
    sha256 cellar: :any,                 arm64_monterey: "2b7232b9ccc6f1a7bff33b658ecb6c719fb60305bbbda64660f5797815452dc6"
    sha256                               sonoma:         "6509d1d01a002e03a802213ca29bf49758b3e8ce2c2e7e3cef5e02a576cfafd1"
    sha256                               ventura:        "854131ea37991a40b5a21c2f5aa4c82824152b1569d9f891a2ecf48265bc3bea"
    sha256                               monterey:       "d0be365943bccb275a108e728bf273a702147e42d2ccf5de3b5cc0a9416321f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e9584f4908a0568a9bc289039b3b4dbecd3dae3f4df38e1f7cccab2b8c6f3b8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV.cxx11
    # force use of homebrew libusb-1.0 instead of included version.
    # force use of homebrew shapelib instead of included version.
    # force use of system zlib instead of included version.
    rm_r "mac/libusb"
    rm_r "shapelib"
    rm_r "zlib"
    shapelib = Formula["shapelib"]
    system "cmake", "-S", ".", "-B", "build",
                    "-DGPSBABEL_WITH_LIBUSB=pkgconfig",
                    "-DGPSBABEL_WITH_SHAPELIB=custom",
                    "-DGPSBABEL_EXTRA_INCLUDE_DIRECTORIES=#{shapelib.opt_include}",
                    "-DGPSBABEL_EXTRA_LINK_LIBRARIES=-L#{shapelib.opt_lib} -lshp",
                    "-DGPSBABEL_WITH_ZLIB=pkgconfig",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "gpsbabel"
    bin.install "build/gpsbabel"
  end

  test do
    (testpath/"test.loc").write <<~EOS
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert_predicate testpath/"test.gpx", :exist?
  end
end