class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.3.2",
      revision: "0b83e5d2f68bc02dfefde74b846bd039f078affa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8c6ade89a35735a3abca92a4e51b1aa6e3dfd1ce5e07ac4bd8aefdc3e769cd21"
    sha256 cellar: :any,                 arm64_sequoia: "c9532539855c59c223a90ee45476aa0dbe5cc2366c3d7d01bf909b2be0a0cf7a"
    sha256 cellar: :any,                 arm64_sonoma:  "93fdfccdcb39f9411940712851867cf8f580fc1bebd0d2d46f18046a9c297060"
    sha256 cellar: :any,                 arm64_ventura: "22ea67f016a8eaad512ac37c79d52c2b87223a47543c77bcbedd8b3e034b1c81"
    sha256 cellar: :any,                 sonoma:        "2bbb88d67337ffb8d639df18694bd98b881a32a83f4dc9cd242936386f48b3fb"
    sha256 cellar: :any,                 ventura:       "fc246c9c62101e2f336a46a1903d743ba06fd2003e0738ccbbb81cf962a5d39e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa63e022242d91f5653264d93d8258096b9e7a05aa9cae9fcb87abfdc7bd6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8b0732026466e3750117f7efdfe8c8c8787220741072cd65c16239a37afece"
  end

  depends_on "cmake" => [:build, :test]
  uses_from_macos "python" => :build

  def install
    args = %w[
      -DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'
      -DENABLE_EXTENSION_AUTOLOADING=1
      -DENABLE_EXTENSION_AUTOINSTALL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The cli tool was renamed (0.1.8 -> 0.1.9)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"duckdb" => "duckdb_cli"
  end

  test do
    sql_commands = <<~SQL
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    SQL

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      │   double    │
      ├─────────────┤
      │        45.0 │
      └─────────────┘
    EOS

    assert_equal expected_output, pipe_output(bin/"duckdb_cli", sql_commands)

    (testpath/"test.cpp").write <<~CPP
      #include "duckdb.hpp"
      #include <iostream>
      using namespace duckdb;
      int main() {
        DuckDB db(nullptr);
        Connection con(db);
        con.Query("CREATE TABLE weather (temp INTEGER)");
        con.Query("INSERT INTO weather (temp) VALUES (40), (45), (50)");
        auto result = con.Query("SELECT AVG(temp) FROM weather");
        std::cout << result->Fetch()->GetValue(0, 0).ToString();
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test_duckdb)
      set(CMAKE_CXX_STANDARD 11)
      find_package(DuckDB REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test duckdb)
    CMAKE

    system "cmake", "-S", testpath, "-B", testpath/"build"
    system "cmake", "--build", testpath/"build"
    assert_equal "45.0", shell_output(testpath/"build"/"test")
  end
end