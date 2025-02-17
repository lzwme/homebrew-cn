class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https:github.compacman82odbc2parquet"
  url "https:github.compacman82odbc2parquetarchiverefstagsv7.0.2.tar.gz"
  sha256 "9ebf9830c3dff9278eb568a0fd5c2c4fd4f279dfdbc83e8029996c563e2c564d"
  license "MIT"
  head "https:github.compacman82odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c8580788086fe8bc43b87ac1f642b1264505a347d0d520e7b680f7e0671a158"
    sha256 cellar: :any,                 arm64_sonoma:  "e837348df1b03ad0a709d24ef0eab5f6e58591212cf2d0267156d7868f62c715"
    sha256 cellar: :any,                 arm64_ventura: "98ba496a26463fca78ec7a330f88ea05f5bc711fcba05ac1e7bf87f004296955"
    sha256 cellar: :any,                 sonoma:        "b912200ad9857000accbfd55230f859a3b2cb37d15b91852f09ca3aae0981675"
    sha256 cellar: :any,                 ventura:       "0e8c36be09cb1f483d4cd7a01b97cd1a06d883c02cc0b219cf551313bf686d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae96b28e08fc9f31966ee3078d394a75274ddec7614047f5c6ed0e7e5fae40d4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    # upstream patch PR to improve dynamic unixODBC library path handling, https:github.compacman82odbc-syspull50
    ENV["RUSTFLAGS"] = "-L#{Formula["unixodbc"].opt_lib}"
    ENV["ODBC_SYS_STATIC_PATH"] = Formula["unixodbc"].opt_lib

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}odbc2parquet --version")

    system bin"odbc2parquet", "list-data-sources"
    system bin"odbc2parquet", "list-drivers"
  end
end