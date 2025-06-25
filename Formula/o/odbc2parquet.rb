class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https:github.compacman82odbc2parquet"
  url "https:github.compacman82odbc2parquetarchiverefstagsv8.0.1.tar.gz"
  sha256 "04d2d0e18e0a1c34d2551faccd5bb639c25132606d42bab41f47cb5de0a7f2e8"
  license "MIT"
  head "https:github.compacman82odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb72da6e019650b691048dd17e2d3069025c0d08bdb9715c5a18bf1f0e135c04"
    sha256 cellar: :any,                 arm64_sonoma:  "13278a9e7cf97eda32214a90f47637f6ec5da6a59da17010e7537ce566393d5a"
    sha256 cellar: :any,                 arm64_ventura: "76bced75bc4f1d23a2c30b10f5ad304b56ea6ac343fd8f9710eef51baf66bd28"
    sha256 cellar: :any,                 sonoma:        "8f16d9b3d6e9c562dd85d86e22a425a3dcaf67b935e76a2002906c46d2265218"
    sha256 cellar: :any,                 ventura:       "18d411f5ab14caa20c734b745bd9bfea79a5f21f9168f40643eaa74c343b1e7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b49ab661dd8bd673e4591affb4485c71cfa2a0f30bf2b6cbcbb167931410e2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9269ada8b5375e1a11ced92450fb7151dc1ecba8383b046035b32688cb2c59"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}odbc2parquet --version")

    system bin"odbc2parquet", "list-data-sources"
    system bin"odbc2parquet", "list-drivers"
  end
end