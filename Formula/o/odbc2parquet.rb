class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.1.tar.gz"
  sha256 "d245d8b657bef162dc3d6ace262950d8b2e9624f4ed8df74afe1ecc45eac95ec"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e769ad0c81bba4e0c3c202e9503096e6e601b039ec4a6b83d3cb931d0c3cca2"
    sha256 cellar: :any,                 arm64_sonoma:  "d697955ef8d3e8b67d3fb8420a78dc30f3cd52ff308dc5e32825fe981d67b868"
    sha256 cellar: :any,                 arm64_ventura: "504bf7d9a0df4aed10e65c8b8e959e1bf9f195c8e534523f1e17688ba8484f60"
    sha256 cellar: :any,                 sonoma:        "2b77d4f5509357e9365c69d62e83458fb0ec2a6b0147d268f06cbb665ea12d9f"
    sha256 cellar: :any,                 ventura:       "6de151267e999ef3fd8e0d5b31b1ff64e71fcedd01b415b4fc532326a28379d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8da592f3c2fcfaf3ef9b6727d8347658827701650c4b9ee3fc4ba2c74da924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2102d2adba5119348533d33d575a0dc8421728f9ab295953880b3db959f55c46"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odbc2parquet --version")

    system bin/"odbc2parquet", "list-data-sources"
    system bin/"odbc2parquet", "list-drivers"
  end
end