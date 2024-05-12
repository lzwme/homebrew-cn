class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.2/ki18n-6.2.0.tar.xz"
  sha256 "8aa8f4740db080f4f0c2ce88d0f289740d55caa06b7f76bf2163d0fb9fd3660f"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/ki18n.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "e46104fb59b5461880f687c5678a2f5d2e9e1e88af14a4e9825c102638a86216"
    sha256 arm64_ventura:  "182e4b96d0a26cfaaa5c9ebe2548b1d757c2d91925c92fdf20e0e53c0b7f431b"
    sha256 arm64_monterey: "e9616fc59f527419d9990b910baf87b1de2b8a6455fbe5b31f1a3cbc759274d2"
    sha256 sonoma:         "89b6201032387a9b4f8b02a4b57b2e4819537123aa1a8bf7811d5338bfcc8e9c"
    sha256 ventura:        "4ef15971f4f40667b34e482e01292dd812e308ec8073dbd6b7e17092c76d3005"
    sha256 monterey:       "f4b51b02165c01a485ef98454a909208f469c85ddc77ecae8fb43a9e199ead3f"
    sha256 x86_64_linux:   "60b11b90472882867a76086cb53b03a8fef92b7a5636295045e9753fd6afd16a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "iso-codes"
  depends_on "qt"

  uses_from_macos "python" => :build, since: :catalina

  fails_with gcc: "5"

  def install
    args = %W[
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
      -DPython3_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    qt = Formula["qt"]
    qt_major = qt.version.major

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM #{version unless build.head?} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      set(CMAKE_CXX_STANDARD 17)
      set(QT_MAJOR_VERSION #{qt_major})
      set(BUILD_WITH_QML ON)
      set(REQUIRED_QT_VERSION #{qt.version})
      find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED Core Qml)
      find_package(KF#{qt_major}I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = if OS.mac?
      %W[
        -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
        -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
      ]
    else
      []
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end