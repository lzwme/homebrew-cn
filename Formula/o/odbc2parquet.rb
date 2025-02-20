class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https:github.compacman82odbc2parquet"
  url "https:github.compacman82odbc2parquetarchiverefstagsv7.0.3.tar.gz"
  sha256 "82c8d0ba16aa14b53893fa33cdc1ea0a8462c6471524c75f4461ff12e13205f8"
  license "MIT"
  head "https:github.compacman82odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7cc336d9cfedc6a95b88ae1ee12a0f6f409642cf676ce3e3a11ea9d12070be7"
    sha256 cellar: :any,                 arm64_sonoma:  "b8e9a38ade9cb11229734325cd0e440b1aeb79d07279a67306f08961baee64d5"
    sha256 cellar: :any,                 arm64_ventura: "b3d05235cacf80a4355f5558d07097f75d564009b2034936ac411db5bae1d07e"
    sha256 cellar: :any,                 sonoma:        "de1a978c07e39f24f95b0bda53f8ef17c87d7c2fc1c8df1faa5f003b372c5bea"
    sha256 cellar: :any,                 ventura:       "865fb3bf59c9d4e7a4629cbbec2d9ca15d15f3e03c463020e36a68ef7a3e77e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89cffd741702c56091c689b9ef1002028096dd4df02e11e2b8773c80cc6f9e33"
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