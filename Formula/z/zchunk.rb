class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https:github.comzchunkzchunk"
  url "https:github.comzchunkzchunkarchiverefstags1.5.1.tar.gz"
  sha256 "2c187055e2206e62cef4559845e7c2ec6ec5a07ce1e0a6044e4342e0c5d7771d"
  license "BSD-2-Clause"
  head "https:github.comzchunkzchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "716e3b4a5e310ef2c2e28981287ad44c34ffb65d8017c266a94e2b2740158263"
    sha256 cellar: :any, arm64_ventura:  "02c1e7311098a207e3c5acdaf951c1f0f79d732190bd26697384de3d297c7a17"
    sha256 cellar: :any, arm64_monterey: "54b3a061081d1d37df726b7453e24a6e68d7916afc752fa3ef251a2233aa96ea"
    sha256 cellar: :any, sonoma:         "07d03afa6c20b2f462ff04f2de17da192bd1be0970cee9606e40b6b735e11894"
    sha256 cellar: :any, ventura:        "9573ef44975ddcd9cd08a67183a3e244303386fad0af7111467dd00f46d5ca5b"
    sha256 cellar: :any, monterey:       "8cc7d00b71b7972981f2360d819c07e6e8da894c5995035ebd77073b911562c6"
    sha256               x86_64_linux:   "65da8bdeab902d65867eda5a3fbda3b6a490827c111872589520e97349b810ee"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin"zck", test_fixtures("test.png")
    system bin"unzck", testpath"test.png.zck"
    assert_equal test_fixtures("test.png").read, (testpath"test.png").read
  end
end