class Ki18n < Formula
  desc "KDE Gettext-based UI text internationalization"
  homepage "https://api.kde.org/frameworks/ki18n/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.112/ki18n-5.112.0.tar.xz"
  sha256 "33d542e760c2bd5dd2d3511624cac3311c60187d7c7b155a4b968a7c6b7a961b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "6d841eb9fe44f81f1a85c65ff75866b1ba94bacd8499d17dd057709c19768b67"
    sha256 cellar: :any,                 arm64_ventura:  "55af29ff56fb4c3f2962b608c905b36c07008b48e7ab0af9e755a8ee2ee2efee"
    sha256 cellar: :any,                 arm64_monterey: "5837f9757264b0bb88a11183c3496b2da026dd7930f31657ccf9a10a0f8bc463"
    sha256 cellar: :any,                 sonoma:         "e5fea5c336856deda5705bc1c1d73ba62dd85bd66ba3950840f18f0eacf70658"
    sha256 cellar: :any,                 ventura:        "305d36763c239529140420a6de17525fd55e0ceeb65b4275cbe395616eb9aac1"
    sha256 cellar: :any,                 monterey:       "5c766ad27d7cd7dfc9bf3515ba115e6a506a250c4ad74b89fbbf4e2cd4dbe431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd6a90d20224d621690f7f18fb4b76dfe4b6e65c75d2d8354b687c7d9ad1d20d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "python@3.11" => :build
  depends_on "gettext"
  depends_on "iso-codes"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
      -DBUILD_WITH_QML=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "autotests"
    (pkgshare/"cmake").install "cmake/FindLibIntl.cmake"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM #{version} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      set(CMAKE_CXX_STANDARD 17)
      set(QT_MAJOR_VERSION 5)
      set(BUILD_WITH_QML ON)
      set(REQUIRED_QT_VERSION #{Formula["qt@5"].version})
      find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED Core Qml)
      find_package(KF5I18n REQUIRED)
      INCLUDE(CheckCXXSourceCompiles)
      find_package(LibIntl)
      set_package_properties(LibIntl PROPERTIES TYPE REQUIRED)
      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath

    args = std_cmake_args + %W[
      -S .
      -B build
      -DQt5_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5
      -DLibIntl_INCLUDE_DIRS=#{Formula["gettext"].include}
      -DLibIntl_LIBRARIES=#{Formula["gettext"].lib}/libintl.dylib
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
  end
end