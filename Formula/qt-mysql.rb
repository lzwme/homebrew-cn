class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtbase-everywhere-src-6.5.0.tar.xz"
  sha256 "fde1aa7b4fbe64ec1b4fc576a57f4688ad1453d2fab59cbadd948a10a6eaf5ef"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f38d7e7a9c85bd8cd36f7a63521a7dad1cb8aab5e12af9537741c31117c6e10"
    sha256 cellar: :any,                 arm64_monterey: "176432238e60f63c3ba16639c2e93ea9514f6a5e28e839075e003f87b016af31"
    sha256 cellar: :any,                 arm64_big_sur:  "d772bc12c3d393d417c20032e639c201ccea5c5b4dd79a8537a7b3afae62e8e0"
    sha256 cellar: :any,                 ventura:        "40372392f2c1feb3fc88666d7da03efb4318f9b4c7f63c83d5ad67e60b3e0851"
    sha256 cellar: :any,                 monterey:       "c1b7d1c5a649495e7fb106a4b1d2bec4472d980702dfe84feaed5841273364e2"
    sha256 cellar: :any,                 big_sur:        "28e86a43db37aaf4b3152d21cbdc324c0e163ff2c6de4c76c78ebf22b8ff1c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7674458fd8f8223efcea745ca5b939639bdf06c4286c6c31018422f93898f8f2"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mysql"
  depends_on "qt"

  conflicts_with "qt-mariadb", "qt-percona-server",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=ON
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_sqlite=OFF
    ]

    cd "src/plugins/sqldrivers" do
      system "cmake", ".", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)
      find_package(Qt6 COMPONENTS Core Sql REQUIRED)
      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Core Qt6::Sql)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console debug
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtSql>
      #include <cassert>
      int main(int argc, char *argv[])
      {
        QCoreApplication::addLibraryPath("#{share}/qt/plugins");
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        assert(db.isValid());
        return 0;
      }
    EOS

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "build"
    system "./build/test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end