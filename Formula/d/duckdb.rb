class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.9.0",
      revision: "0d84ccf478578278b2d1168675b8b93c60f78a5e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d18542d913fba90f296f8b0519ce07713bd638299377e8f000b3e6909cd58d0d"
    sha256 cellar: :any,                 arm64_ventura:  "1dc9ff97a29f128d0c0dbc97db02348b9f3dbf7d4279351f2ab2c0480216babd"
    sha256 cellar: :any,                 arm64_monterey: "db272754f45c59a06f1c17a297438a3dec6054339933e67ac41da8c8e2d2716a"
    sha256 cellar: :any,                 sonoma:         "d8c710feb90678e72ce66b56914ff9417840f3114c416cb0dfbfd220fe229315"
    sha256 cellar: :any,                 ventura:        "8fcfe1f5893ad2f401907ad5530443738dc81fce76f7e7371624529d0cc5e5d1"
    sha256 cellar: :any,                 monterey:       "bf2c2aa3e465f436d4548e9056780c84af130313cc38b95a7f601ca25f8471f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6597b61d124f60ff9dae4104af5ade0bd8bc05618e7232f81b33c10a21b521"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'",
             "-DCMAKE_LTO=thin", "-DENABLE_EXTENSION_AUTOLOADING=1",
             "-DENABLE_EXTENSION_AUTOINSTALL=1"
      system "make"
      system "make", "install"
      bin.install "duckdb"
      # The cli tool was renamed (0.1.8 -> 0.1.9)
      # Create a symlink to not break compatibility
      bin.install_symlink bin/"duckdb" => "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      │   double    │
      ├─────────────┤
      │        45.0 │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end