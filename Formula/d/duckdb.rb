class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https:www.duckdb.org"
  url "https:github.comduckdbduckdb.git",
      tag:      "v0.10.3",
      revision: "70fd6a8a2450c1e2a7d0547d4c0666a649dc378e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37190da7084433cc22f66bafae21d814263fd6f5744602160d91d2f9bcc4d6c7"
    sha256 cellar: :any,                 arm64_ventura:  "2b30ad64e2fe27627c2111f2fc789ce8b79d7a53c8f17c18f72c59184f3b9f8a"
    sha256 cellar: :any,                 arm64_monterey: "0d448a5835b42bd772efa78b956ac94cd57ba245df380c89742bd5e858359bcc"
    sha256 cellar: :any,                 sonoma:         "9deb40a80ba774bfbb75b5c79a67646e981c1764cc00d06fc3bb397f6367f0a9"
    sha256 cellar: :any,                 ventura:        "5b4eab4ec47f768185fa9be2cd273792cad6f89189e3dd8a1a269e8b0019a903"
    sha256 cellar: :any,                 monterey:       "07ae953da082510ccf3f513d3ea50acbebfd407ea3a5a3593820f2674ba1c54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c73f8a7191ccc1f63059143d147fea09e829987d42b754b0d4b667dcf58d2ec5"
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