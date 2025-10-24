class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.3.tar.gz"
  sha256 "a0a08c8aaf9e68fc2e5803b20ac7bcbaabe797be1a69321ababb88971a324717"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0775d8375374d2a52e5aa20ed8c7ee5bf5d62c49e7c7f751d67316fce8f8e273"
    sha256 cellar: :any,                 arm64_sequoia: "6329cfd87e98aa1975c4300c1ad3412cbeed5445fbe6f24e146b1eba8d603acc"
    sha256 cellar: :any,                 arm64_sonoma:  "e2376b9f3db1e74580457b40068e517eaeda1edc11702fae1e5f011b7575e26d"
    sha256 cellar: :any,                 sonoma:        "140d6737a7cbcc6618194d5364709872324d310c2c147f371f0edcdc0a91b78d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c6881eb2b6a4673a29c192e02521947674a8b65f01cd333157bda48b9c8e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b53a75f57603025cbc9e498c782f8ef8155c0ee34881563427d6841a65b958e"
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