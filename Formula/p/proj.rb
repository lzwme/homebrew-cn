class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https:proj.org"
  url "https:github.comOSGeoPROJreleasesdownload9.3.1proj-9.3.1.tar.gz"
  sha256 "b0f919cb9e1f42f803a3e616c2b63a78e4d81ecfaed80978d570d3a5e29d10bc"
  license "MIT"
  head "https:github.comOSGeoproj.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "ec90fde843082577113b551174890de34996913041ad149b061dfa9aa62cbcd0"
    sha256 arm64_ventura:  "914612ca94469bc830cfc54a27a1c30c4d2cb185348b56461023e9e3cbe7b0df"
    sha256 arm64_monterey: "bcd30ef6db92f4dda465674248e8ffe2b148c62d8bef53369287e05c6d652bc6"
    sha256 sonoma:         "d89281fe85509b2e0943e9ad6821e53e4461a15ac3404a86a4ddfa6a4f7dbe44"
    sha256 ventura:        "4a7f126c9f904b3a71079273a8e473d8f28f01029432ab1ff60620869e015d0c"
    sha256 monterey:       "d05c1cd472dbb8b63f858245d85dcb6dd7674f964f575b37a946a8ecf5ec9549"
    sha256 x86_64_linux:   "bacd9d3ac5acd4c2475723bd50ab98be04be5675120b949370750b77eaa30e53"
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
    url "https:download.osgeo.orgprojproj-data-1.16.tar.gz"
    sha256 "21a31840c86c23b9926bafebb847bacff8f88728779c3a9bd0f9b2edf8135a01"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install Dir["staticlib*.a"]
    resource("proj-data").stage do
      cp_r Dir["*"], pkgshare
    end
  end

  test do
    (testpath"test").write <<~EOS
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

    output = shell_output("#{bin}proj +proj=poly +ellps=clrk66 -r #{testpath}test")
    assert_equal match, output
  end
end