class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "d76320c3b3704f89de9c00e1886441970b04379639704562277907f763b429eb"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52256984f6e35aa7d8a5a1ad9c74a18f83342027bfd3fd4d58f036f09413a655"
    sha256 cellar: :any,                 arm64_sequoia: "6f4720ed367ce3fd82caa58c9c492c9c323340a321ff77a163696fae19e8ebe0"
    sha256 cellar: :any,                 arm64_sonoma:  "ac96aad8997492e9406bfb8a81a1abfb063743f04a00e96599f57cdab7c1700c"
    sha256 cellar: :any,                 sonoma:        "ac450d1ca884823d0bb2e85a65425d028c68a6c9fd333ca5923505022743cc25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99777c273d431588944ede311c4d57c22709a7f0c4f9f8602c304b5e131a7330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61835b70c2ade1ac88458b85cda1a5e04dc68b1668d5105b6d7693dd0cdd0cc8"
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