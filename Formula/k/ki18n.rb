class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.4/ki18n-6.4.0.tar.xz"
  sha256 "c069e559e3a311bf977f136d77732c5f3e4253752deff9ba999a6a8d7b4ae255"
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
    sha256 arm64_sonoma:   "04b0c002fd7f6e27dd92fc92c2d6761becbab844503bd159295a9b91b860e6a6"
    sha256 arm64_ventura:  "3b0f41fbb58cd2b56b84d8c677732c0ac84dc14bd18943f299796d97dadd735b"
    sha256 arm64_monterey: "0bf6675e4fb904d5b3b1b98c08880189c69289e447be54e17c7083512dfa822a"
    sha256 sonoma:         "76fabf9312edfffc127b9586bc74b55e499eab4ba22495f304f29d0cbb58c89d"
    sha256 ventura:        "0c57bdf5fe02211117e341da6e10e088b7bff4523c372477057ed69b5604d960"
    sha256 monterey:       "8d67fcf3061359bdd36cdf1aa297d7a41f993cb591e818b2db82279e5310b81e"
    sha256 x86_64_linux:   "faa1ca53fd2d6708dac3d3a2bf6c97deea8a54ef3f99a8f735a222575f16276c"
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