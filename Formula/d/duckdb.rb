class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https:www.duckdb.org"
  url "https:github.comduckdbduckdb.git",
      tag:      "v1.1.0",
      revision: "fa5c2fe15f3da5f32397b009196c0895fce60820"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "47d151c2267a001a305fb84db8b72d8c272b12bab12728dc326191ec54585522"
    sha256 cellar: :any,                 arm64_sonoma:   "64809434767d707995f88a531052d0a7e87ab994dfd1a5290a6693549f8dd810"
    sha256 cellar: :any,                 arm64_ventura:  "0aa06f44102a9555591af2652c0acdfa2b6fdc86ab0282d3f35fe3dff1074423"
    sha256 cellar: :any,                 arm64_monterey: "c6954cec4f2375776ff7dbbd540939b167773c28c7302a3f290e4370e460ca50"
    sha256 cellar: :any,                 sonoma:         "59b4ba0bc0d0bbdfbf0063c86b575bca2163e5b093d9a1b7f6e04f6cf94e9661"
    sha256 cellar: :any,                 ventura:        "22f42b7030e34ca7fa638396e2a4e00d5a5697b1fb7934d367dcce74f5890f63"
    sha256 cellar: :any,                 monterey:       "fd3398c4cb5feb442b523dbb249befe1fc75045bf24cf02125ea92b4745d51c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ffa5ecaffab080e827990da3fba0724b5c5ca62fc8b5ed476cf022ef561e744"
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
  end

  test do
    path = testpath"weather.sql"
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

    assert_equal expected_output, shell_output("#{bin}duckdb_cli < #{path}")
  end
end