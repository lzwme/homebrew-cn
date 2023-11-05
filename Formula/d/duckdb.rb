class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.9.1",
      revision: "401c8061c6ece35949cac58c7770cc755710ca86"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c4a8b868083bdb727a1ccaef157ce6d7fd1c124ea863ddf9e44dc6e309c9312"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec8156408c76e69677f194400e8f8e7dafa27612793522eda5182014b5d4da3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcad466ca906f96e114bd0207c31152b666b1cd4fa8fa0b03a2b6d3299ea6c5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3aaf2f002b0914cd1fbc36d008cab1a3bb6888ca727f7548a321e2f27d424fa"
    sha256 cellar: :any_skip_relocation, ventura:        "e94502626807a8bd7cf010af173aab8cba93d946857313fdf35f98880e165c66"
    sha256 cellar: :any_skip_relocation, monterey:       "b23240ca3ce4fb4dd73ba9742b6974dc7268f632596455214be043e1b4e8ad7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef8f4d2be9d94cfa27cf290a920154a2fe0b294280152e8093411e3ac2a5c01"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'",
             "-DENABLE_EXTENSION_AUTOLOADING=1",
             "-DENABLE_EXTENSION_AUTOINSTALL=1"
      system "make"
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