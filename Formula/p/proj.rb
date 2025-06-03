class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https:proj.org"
  url "https:github.comOSGeoPROJreleasesdownload9.6.1proj-9.6.1.tar.gz"
  sha256 "493a8f801bfdaadf9dc50e5bc58e4fcc9186f1557accab3acccbd7e7ae423132"
  license "MIT"
  head "https:github.comOSGeoproj.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "250dd33b9d7d84b578efadb8fc5e6c579f93567c63e62c021bbb006704cb765f"
    sha256 arm64_sonoma:  "5fe7b04184a7c60c4ec116901c0cccc936b4b76049c5282c85bb2e07eb0d9eb6"
    sha256 arm64_ventura: "abd2b2214df6468dee25e9d05ef6cb40645fef3b3d5be07cbbf24aaea76e9d81"
    sha256 sonoma:        "2d75a45d98e7a9cce3005c1cc7d768d1f30a0cb0ed915eed6043276758d63c08"
    sha256 ventura:       "b4b0bf36ab38965ee97149addfab6bca64924399f35d6cc0af09508cb114d98c"
    sha256 arm64_linux:   "dc8a4f4c33acf11043f198ba38cb934059fe5926f5ac20f3abb14bbca122d3b7"
    sha256 x86_64_linux:  "827d09fd7226cfd46e221a2735265443ee8959becc7cc9ed8befe109c487bd19"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "proj-data" do
    url "https:download.osgeo.orgprojproj-data-1.22.zip"
    sha256 "ebca54b7f9118beafd30a5abeaeacfee6be9f59a0bb52419c9282cf34ee2510a"
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