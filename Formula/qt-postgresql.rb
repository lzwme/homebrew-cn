class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtbase-everywhere-src-6.5.0.tar.xz"
  sha256 "fde1aa7b4fbe64ec1b4fc576a57f4688ad1453d2fab59cbadd948a10a6eaf5ef"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "758d0feb12bcddb207ce8e5c43672fc2d9ed276e9f8fdac8dad77f6adfb084a9"
    sha256 cellar: :any,                 arm64_monterey: "021806da6471ffe984731a8234ddd432cd67e54635771a41dbb1abd62ceccdae"
    sha256 cellar: :any,                 arm64_big_sur:  "2878e95091406c0cdfc4e6285af1ecfc11b0914002f671f573c34a13a7641ef2"
    sha256 cellar: :any,                 ventura:        "0afada8390fbb2128faf788ace6cf3888e7f3a517ae3dcccd23f9c16e1ea6623"
    sha256 cellar: :any,                 monterey:       "f2a030e1f6c0236607ad786e99876f47cf99ca2bc086d52e487eaac33576345d"
    sha256 cellar: :any,                 big_sur:        "8c77ba1da4e2bbfa0528d6dacf8a36addea4d3c938f5b81d73499f385ac688ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0737a81a6252a2c310275f0ffff0c49fd7c5afbc5c84f7bfa8ab1f84a080c2"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libpq"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=ON
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
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