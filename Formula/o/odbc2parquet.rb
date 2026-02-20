class Odbc2parquet < Formula
  desc "CLI to query an ODBC data source and write the result into a Parquet file"
  homepage "https://github.com/pacman82/odbc2parquet"
  url "https://ghfast.top/https://github.com/pacman82/odbc2parquet/archive/refs/tags/v8.1.5.tar.gz"
  sha256 "c54a8f8127238ee1034301a75af6cc505f2f64b0167fce44f2e7a3dabffb3aa0"
  license "MIT"
  head "https://github.com/pacman82/odbc2parquet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "179853e390c07f6657e1a39a7f495ca4bff961ed3e8b297186d79d4d1d7c8701"
    sha256 cellar: :any,                 arm64_sequoia: "4d7a48b840b255bd946da7546fde74ae02dd2628a518fe6722032cf2903b92ca"
    sha256 cellar: :any,                 arm64_sonoma:  "ef82f56b718e9600c6acf2a852171f891096e69e5614f908a71598fff10f6338"
    sha256 cellar: :any,                 sonoma:        "049561614d6ce7e7b7dfb94bdcba4c6bc04234b2885a568c1adb0b0f0254fd9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebfeff3a52faf0e9751cb4aad896c2b48995a6e512aa08add52d3c1943ba6a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c63235b7cb24d9cbd60efb253a2da63a78ff09b17f28cedf6c067e666ed3629"
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