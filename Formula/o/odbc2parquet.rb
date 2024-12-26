class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https:github.compacman82odbc2parquet"
  url "https:github.compacman82odbc2parquetarchiverefstagsv6.3.1.tar.gz"
  sha256 "02aaa8358311f5551dc8c966563ac2adc637897070717da2249611522f3ada9c"
  license "MIT"
  head "https:github.compacman82odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c127ed1d31a4716cdfa3d39019769e2826589e7071e39a085c52c7cfefed43dd"
    sha256 cellar: :any,                 arm64_sonoma:  "436af15821db55593d14af9866169eb2aff5ed14142bcf227c3788dc8f944c8a"
    sha256 cellar: :any,                 arm64_ventura: "9030aad4adb8a44069aca011d6b10e679959b22f34236507973d2ddc5d1665e8"
    sha256 cellar: :any,                 sonoma:        "f986e20a827ba9f3f56d5500146ef4f51e3e0330ce14c2964f49782555640eb4"
    sha256 cellar: :any,                 ventura:       "79845a24e840157eed1f55181cbc1455c53b13e17f8be5cf0b5875f7f5e1d7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "957fb36c957dde2d24d3d835c9612a74a870ac159f3844ade44c752c3f1247eb"
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