class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https:iamb.chat"
  url "https:github.comulyssaiambarchiverefstagsv0.0.9.tar.gz"
  sha256 "7ef6d23a957bfab62decd48caa83c106a49d95760b4b2ccf5a6b6a8f4506e687"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cab5d35740fd2832dcde429cc9df774cfa3b9d1579a0b7a35efd4415f10b956"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8db5d3c266cbe234879b1bf76a1890476b412d794c53bc63254dcc202c0397da"
    sha256 cellar: :any,                 arm64_monterey: "4a35bd0e9d01e9c96ce7844a8df38867b861ad9e37db45896a013c30ba851ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bb9be42d3ac4267f5943e7680f0f469ab5760ef2508a4bc9837546a38a2442b"
    sha256 cellar: :any_skip_relocation, ventura:        "25350de312e8b735a1897e3e3911682a35af36be0303423924339d1fa1328708"
    sha256 cellar: :any,                 monterey:       "12f5a1ff4a6ecb6f0ee8e42c0ab396730156cd3aa2eede35046c23f17ced953d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f34306ea161183155adbc5ad456bb3ae91c43c16104b88077ff0d527c735a3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "sqlite", since: :ventura # requires sqlite3_error_offset

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Please create a configuration file", shell_output(bin"iamb", 2)
  end
end