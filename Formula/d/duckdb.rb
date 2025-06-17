class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https:www.duckdb.org"
  url "https:github.comduckdbduckdb.git",
      tag:      "v1.3.1",
      revision: "2063dda3e6bd955c364ce8e61939c6248a907be6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0ff6ca13bd058992bd062e8eb99db7cb0fe2c822024f5f67a18e9bd690400e5"
    sha256 cellar: :any,                 arm64_sonoma:  "fbf85ebe679e4ee1b092b9d76d59061a774b5256219189fdcdaccb792941d82c"
    sha256 cellar: :any,                 arm64_ventura: "300591029a93d4defb23e6037257df5b1e7f3164fcbb62fc72ebeeed89955404"
    sha256 cellar: :any,                 sonoma:        "0099d9d26493779c1d615cca1653fe1bc6e71a044aba535f7da6b448454504e9"
    sha256 cellar: :any,                 ventura:       "234e8f8e776b037a2219ed6a25f8bed78994d86cf24fa0af41cd22f3f0987fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a4494d79ddd9f9583bf78d12dea2a1539b35202f575e277caf61564db66728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d6509b291dae694d0392c5f53d3b029b942687ccb2e3333dc032408d0eaa260"
  end

  depends_on "cmake" => :build
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
    bin.install_symlink bin"duckdb" => "duckdb_cli"

    rm lib.glob("*.a")
  end

  test do
    path = testpath"weather.sql"
    path.write <<~SQL
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

    assert_equal expected_output, shell_output("#{bin}duckdb_cli < #{path}")
  end
end