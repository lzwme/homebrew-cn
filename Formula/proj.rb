class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://ghproxy.com/https://github.com/OSGeo/PROJ/releases/download/9.1.1/proj-9.1.1.tar.gz"
  sha256 "003cd4010e52bb5eb8f7de1c143753aa830c8902b6ed01209f294846e40e6d39"
  license "MIT"
  head "https://github.com/OSGeo/proj.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "87626c646b17ae0d9bf7d0f4b5ce2085653b2ea250ddd971ffa2967191c49318"
    sha256 arm64_monterey: "3850d1fd423d04f540a977bbefda4ef56b542ec721885922554887cd21065c45"
    sha256 arm64_big_sur:  "f78ad291c6f4caeeb490b0ad9f8e779ec300e4c582bc79e9ab8d3af0298fe010"
    sha256 ventura:        "1a9736c2539545a7290f8a2420ddab1a20821b2ebddc166b83c78fbbab8bb2f6"
    sha256 monterey:       "6755cb73b8ea5fe6697716631f4d98e498006a76b0cab8aa61e51feed77057f8"
    sha256 big_sur:        "37c9291e10346ca821b43bea0638448e4425426f6989d01e0f649070b8adc495"
    sha256 x86_64_linux:   "aeae0765e8b34e863528dbd651a33406be2cd0066dd15a22e50c571df35e440c"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "proj-data" do
    url "https://download.osgeo.org/proj/proj-data-1.11.tar.gz"
    sha256 "a67b7ce4622c30be6bce3a43461e8d848da153c3b171beebbbea28f64d4ef363"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["static/lib/*.a"]
    resource("proj-data").stage do
      cp_r Dir["*"], pkgshare
    end
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS

    output = shell_output("#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test")
    assert_equal match, output
  end
end