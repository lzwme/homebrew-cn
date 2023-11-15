class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.9.2",
      revision: "3c695d7ba94d95d9facee48d395f46ed0bd72b46"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9dacf6c11b9daaaca5bb3620bf17a189ae155a1c2473954a81ce9a68a7cf75b9"
    sha256 cellar: :any,                 arm64_ventura:  "4bd0994bacdb745f6faf055decc1abf3c3fbc66e7c9955298d6bb0cb8fbe730b"
    sha256 cellar: :any,                 arm64_monterey: "776435a9c411fed2b471ab9a778a9a39691b6563e50357aa5c3d3864e103463d"
    sha256 cellar: :any,                 sonoma:         "52230fa3d6f6b0963c0d06c41a8e8f56f774f0a7282cc9ec51469fefef7aa2d6"
    sha256 cellar: :any,                 ventura:        "dcc39782aff5214ae3c42e8b342bf7a8b4aa30eaa5700edce46b0159937ec0cf"
    sha256 cellar: :any,                 monterey:       "4a144cfc8abe54ddb6e73c70862b321ad35472cd85967bd8033e0485a1b7b7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6bd88b58993a528dbfc819f92f011a0e68f24e293ced4d449738866c806acdf"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'",
             "-DENABLE_EXTENSION_AUTOLOADING=1",
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