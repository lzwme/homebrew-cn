class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.114/kdoctools-5.114.0.tar.xz"
    sha256 "fb883f7e3a95535fad243059f91cb302a31820ca31e1d4c1e093b5fd45464597"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1080912761af9a1349dac88cf1b51badbd3f845e22ef1fc824478d52fad55b48"
    sha256 cellar: :any,                 arm64_ventura:  "a367099c79a4bd6077fd2c8d2843def044faa1c1d1eefade7782cf9f58e1b06a"
    sha256 cellar: :any,                 arm64_monterey: "874510dff56e3a6fdfe561d71d403e62e564226580a2ad1c314df616fe5e194f"
    sha256 cellar: :any,                 sonoma:         "34b323cbbaadbb4f32a0998262762bbd89a94ba81e345709bc7b380b55c4b6f3"
    sha256 cellar: :any,                 ventura:        "9585bf1a6f7030c8c9710081c6d558cf60c11bc13fc28f763af10ab170dfbd82"
    sha256 cellar: :any,                 monterey:       "957d6837eb6910232a77739c094eb409d2bd406117d534bf3a8c75cf57c42f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "288a851de0e3d8fc46d98a294e8fe3d757355e700806758f9a68aa01bc665554"
  end

  head do
    url "https://invent.kde.org/frameworks/kdoctools.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "ki18n" => :build

  depends_on "docbook-xsl"
  depends_on "karchive"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  fails_with gcc: "5"

  resource "URI::Escape" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.21.tar.gz"
      sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      resource("URI::Escape").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    if build.head?
      # Remove `qt@5` paths from `karchive` stable as users will need to install
      # `karchive` head to match the KDE Frameworks version.
      ENV.remove "HOMEBREW_INCLUDE_PATHS", Formula["qt@5"].opt_include
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["qt@5"].opt_lib
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install ["cmake", "autotests", "tests"]
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
      find_package(Qt#{qt_major} #{qt.version} REQUIRED Core)
      find_package(KF#{qt_major}DocTools REQUIRED)

      find_package(LibXslt)
      set_package_properties(LibXslt PROPERTIES TYPE REQUIRED)

      find_package(LibXml2)
      set_package_properties(LibXml2 PROPERTIES TYPE REQUIRED)

      if (NOT LIBXML2_XMLLINT_EXECUTABLE)
         message(FATAL_ERROR "xmllint is required to process DocBook XML")
      endif()

      find_package(DocBookXML4 "4.5")
      set_package_properties(DocBookXML4 PROPERTIES TYPE REQUIRED)

      find_package(DocBookXSL)
      set_package_properties(DocBookXSL PROPERTIES TYPE REQUIRED)

      remove_definitions(-DQT_NO_CAST_FROM_ASCII)
      add_definitions(-DQT_NO_FOREACH)

      add_subdirectory(autotests)
      add_subdirectory(tests/create-from-current-dir-test)
      add_subdirectory(tests/kdoctools_install-test)
    EOS

    cp_r (pkgshare/"autotests"), testpath
    cp_r (pkgshare/"tests"), testpath

    args = %W[-DQt#{qt_major}_DIR=#{qt.opt_lib}/cmake/Qt#{qt_major}]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
  end
end