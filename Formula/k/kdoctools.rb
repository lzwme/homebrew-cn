class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.2/kdoctools-6.2.0.tar.xz"
  sha256 "ecf38556ec5f9d99ee2ceb2c28727f4c80342217cb69b9aa945a6f702dc3ff4f"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/kdoctools.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3efe31f0d4c7cc4077c757d84ba8467fe2e44113508ce2c6e5c135bdb3bc26af"
    sha256 cellar: :any,                 arm64_ventura:  "2a0db68f9f7eddd965375bb696b1d3324c450f6a5806658bc05949d821dcb768"
    sha256 cellar: :any,                 arm64_monterey: "3b74f1f6b7e6e82518c74cddd4a71101ee956bc7623a8e9acd641079328599af"
    sha256 cellar: :any,                 sonoma:         "099b873c505ee0c8d8305ec77ee5c5bd511463b347d583732dd912f248996fde"
    sha256 cellar: :any,                 ventura:        "f0b7efba99f64c11a94a6ac48164e1a0f3e39b9f6df52ac2bed4c04161e33285"
    sha256 cellar: :any,                 monterey:       "cc095e15e58ef4bf4ea287b1129c7e2c26ace229c466a9bf5f61d07d124bbc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1e439884a2cfc2f1323ae8f2d9d5d12cbfa279b3d13c9ac3ec4ae198dca68b2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "ki18n" => :build
  depends_on "docbook-xsl"
  depends_on "karchive"
  depends_on "qt"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  fails_with gcc: "5"

  resource "URI::Escape" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.27.tar.gz"
      sha256 "11962d8a8a8496906e5d34774affc235a1c95c112d390c0b4171f3e91e9e2a97"
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

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install ["cmake", "autotests", "tests"]
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end