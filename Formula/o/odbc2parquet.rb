class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https:github.compacman82odbc2parquet"
  url "https:github.compacman82odbc2parquetarchiverefstagsv6.3.2.tar.gz"
  sha256 "3ca5a814d739773372af07696d67a0eeaf1d2708b951ed10a4e5fe4c80943e09"
  license "MIT"
  head "https:github.compacman82odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be103589f91c87e60b714bce4ece2c67691bd993a99c5ee0d0d43c862456884e"
    sha256 cellar: :any,                 arm64_sonoma:  "dbe6a3f894bf73991fafb3e2c4dee375613cede76c15b0c3c9ca5d790f2bce98"
    sha256 cellar: :any,                 arm64_ventura: "64aa16afa01c011cd683c7ac2c807372fa108cc16d9a919637bcceafa6e19735"
    sha256 cellar: :any,                 sonoma:        "b470091fe4b6ff8bb76ccf43fb6f9379e7432732139cfd0bf04aa9b474d5a24a"
    sha256 cellar: :any,                 ventura:       "4bad5379fa9c8c73612cafa60386e9f8c2420ba0e2022750eaebf93996fccfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a97c4ecba63cea7f3a6492d9d38ba5c90df32ff68c56a4eb76c169cf9fd15054"
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