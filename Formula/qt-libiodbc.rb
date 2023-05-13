class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtbase-everywhere-src-6.5.0.tar.xz"
  sha256 "fde1aa7b4fbe64ec1b4fc576a57f4688ad1453d2fab59cbadd948a10a6eaf5ef"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18196779291b8e883a85ad04abaaa046f0272e6fc3152b83478cbbd7c90568ca"
    sha256 cellar: :any,                 arm64_monterey: "08fe2a7fdb3f0f5ad0b6f3ff773caa7c9ce42241cd714f86845d5e840a1dac96"
    sha256 cellar: :any,                 arm64_big_sur:  "7cb6099ff3398bcfc9a9a2f391e2b90843fbaa3012af729b9ccc6df716e2757f"
    sha256 cellar: :any,                 ventura:        "f82a773f75b0208891b39313a4c0f2b043c540d3003812009234810de26c2806"
    sha256 cellar: :any,                 monterey:       "d9695e3e76c2f56b18682c1cde852b2d770e300255822a5d30d9ffb0f73a96b5"
    sha256 cellar: :any,                 big_sur:        "27e942210669e079c36e2b4e759b096836abf3fa0097bd9fef03d483e91d43a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529363a410f6fe9457f4adebdc60ffcf62c7f4d516dec6fa1b20907672947e11"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libiodbc"
  depends_on "qt"

  conflicts_with "qt-unixodbc",
    because: "qt-unixodbc and qt-libiodbc install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=ON
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
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