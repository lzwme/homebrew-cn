class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.5.tar.gz"
  sha256 "c54a8f8127238ee1034301a75af6cc505f2f64b0167fce44f2e7a3dabffb3aa0"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8571d2e2a5871d261c512038e1ce024e12905aa04f1385badb5261659a3e6a9e"
    sha256 cellar: :any,                 arm64_sequoia: "b973ab6e5a6899645a492fbcf654a8104350d6523b07095376eb7e4cfc1f8655"
    sha256 cellar: :any,                 arm64_sonoma:  "a943d3f56de3746d77be2e57eff3face7fe217ffdd026f9a55ae91db530c0a6d"
    sha256 cellar: :any,                 sonoma:        "df5c05c02627d273ba68e883ff2c7aaaa332c68745ba01bd24406a44df4563bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1e8053f06692557a9d33f5f11538865cfc0b8c9d4d4a1c4a3b0d1981ea20b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c46145c58b33f8956f9690853dc34c5b52af7015b784dc04d38b34fa0b1520f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"odbc2parquet", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end