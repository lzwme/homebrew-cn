class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.4.1",
      revision: "b390a7c3760bd95926fe8aefde20d04b349b472e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e434f12d6815f25d8bd757db6defa0f56fd52684ee482264d874b81ec18434a"
    sha256 cellar: :any,                 arm64_sequoia: "aa95bf4f948e60735d5ddfd3fb8e45b00f57574570ece6d3b25e78ef5991c188"
    sha256 cellar: :any,                 arm64_sonoma:  "449fe9e785f42a481fbe8211881fe6fe86654eb71ca9f0d2939cb955e803cd04"
    sha256 cellar: :any,                 sonoma:        "547ba7d93f6fd4f1944d95e94d694ed80b60f01a84efad66c71cd2c260797b70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fa9104dcb0b037c9b590bcb7b415182e81c39b597bc4c8f295fa95e3c01275e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5b04911564eafbb24eaa02a52044c1119b81c70115f9999a3fd512a1734b3c"
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