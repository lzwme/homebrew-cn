class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.114/ki18n-5.114.0.tar.xz"
    sha256 "1ba88bf8b6dcbe0136f193839a3e49354fab400c69f3b71e355e95ceb81ae0f9"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "2836654205f381bcc0a2417d9e3c7bd6fd64d2d096e0df2ebc72d102772e8207"
    sha256 arm64_ventura:  "52b3a4e27d08c014fe3a2fed7c3c9c81129b140b9f060400061aaf60c5a8063b"
    sha256 arm64_monterey: "44298bc7b18b0b72e832307391878138e96b22fb8021d3583e6de81df251be2f"
    sha256 sonoma:         "7add0280b8b09d7e508efe5447843c74e6ef8c9e8c0cee0d36ec18af74fe88cd"
    sha256 ventura:        "3117ec8e7621381f1168bb0e6f9e2623cd15d4211fa5fa03d7dc1f4453bada57"
    sha256 monterey:       "e3ef49e6e3d279caa233464193fd58c83dabef6d969683913fecc4d0016ac014"
    sha256 x86_64_linux:   "b3daeaa12b07becbf8257a22887e5304770b73c655f65dc821607b2f45c9e91f"
  end

  head do
    url "https://invent.kde.org/frameworks/ki18n.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "iso-codes"

  uses_from_macos "python" => :build, since: :catalina

  fails_with gcc: "5"

  def install
    # TODO: Change to only use Python3_EXECUTABLE when KDE 6 (Qt 6) is released
    python_variable = build.head? ? "Python3_EXECUTABLE" : "PYTHON_EXECUTABLE"

    args = %W[
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
      -D#{python_variable}=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    qt = Formula[build.head? ? "qt" : "qt@5"]
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

    args = %W[-DQt#{qt_major}_DIR=#{qt.opt_lib}/cmake/Qt#{qt_major}]
    if OS.mac?
      args += %W[
        -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
        -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end