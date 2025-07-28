class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://ghfast.top/https://github.com/houseabsolute/ubi/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "fd88f8b1b58ee2bcef056da00868f4bdb1cf67560a90fd4a63b6f586883c6488"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c416b811d751850f89055b49eb8d448d59669ebc83485c6019b91e157247837b"
    sha256 cellar: :any,                 arm64_sonoma:  "6f9bee452826d7b2e70c10cb0c188e884be83264baa1d07dd6aa55413df19cbc"
    sha256 cellar: :any,                 arm64_ventura: "1f23855ac3c7c630c2c4604ae719902084684b69bb4a97a81db479e20752d124"
    sha256 cellar: :any,                 sonoma:        "352c1bf1f74d3b19b3c03042e9488ae89368a58f80e9d439518a89fca49d8e9d"
    sha256 cellar: :any,                 ventura:       "4ca83c0a35c29ef0a14ad46625aa0a669cf6eeb71b07d2bc13d53d73800e6189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9bd180ad2229fa9bed00e8f2ecbe43dce3343926cdffab2ba1f6dedb5f9f81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed856ddf85f9cb31031e701ccebc276ca9281daf7aecbd6478a7515d4009ee1b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end