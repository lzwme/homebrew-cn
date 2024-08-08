class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.4/kdoctools-6.4.0.tar.xz"
  sha256 "63e112f907118cafd4584ce8eb3149d3557a7f9e9a4005d10c40cccf46d24dc2"
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
    sha256 cellar: :any,                 arm64_sonoma:   "19596a4d492a1e677b78bba3f77ec911fb7fe1cecbb192f58cb2581dc188bb76"
    sha256 cellar: :any,                 arm64_ventura:  "57a9dcfad17d9cec4c26f765b530259c53722d6031664011e960c2eed503d451"
    sha256 cellar: :any,                 arm64_monterey: "8c82e00b9f1006ec5595e2bc14c2e0410028069008085b97c175bddc30fd1b75"
    sha256 cellar: :any,                 sonoma:         "d53f9465db7eaff9575be45feada20042fd840a49a2b07b06e6665659e544f75"
    sha256 cellar: :any,                 ventura:        "6d95d429930435755126ef3f44e7641edf96a809f6bdb3f3094618c6b0bc52d8"
    sha256 cellar: :any,                 monterey:       "8ff33154a699f58c1922256e285f3861eb9c3d231145133dc31236fdcfcc0936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90897b1b2ee4cc8c1a5c4d367a17dd8202a9550a0a746b797db47d5041f99203"
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
      find_package(ECM #{version} NO_MODULE)
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