class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.6.tar.gz"
  sha256 "12922a7fb10ab5745b20cd9020f47f518f85601545f9bb38d9264d0c3d769125"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f08f2f96ba5ce06636afe5ca933ee6c7b95b072e09989a9ad17a108ff51a217"
    sha256 cellar: :any,                 arm64_sequoia: "606448e550fa27032ec23344a2ee4c921559479146e979087774e8eae7f4f7fb"
    sha256 cellar: :any,                 arm64_sonoma:  "120328018415246c2904c07833112f52d5958f9c267838673e36889393a6da13"
    sha256 cellar: :any,                 sonoma:        "556f7be800b8124db0dde42557f70533e4ad90f951eed3b8832fdae3626680ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aaba4bc94196bf33fd8abb0c8bee9e700ec52cacb8fcf00e8411e8ebb444968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204fdde3ae62dc2805f0272f8dc67a16003dc35cad39f4610bb10bae73972e99"
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