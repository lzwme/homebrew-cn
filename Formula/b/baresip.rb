class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.12.0.tar.gz"
  sha256 "56373a116e4250b626602e8ab789448277cc992586124e389d0b8ef26f610af8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "8a35848b7260c262de71801eee3964f2b305aa707a249ae2ad506277a2eb6b74"
    sha256 arm64_ventura:  "e2e1d38b3085164cea66924c7bd1c44825d224043575147ef669df7f16214c97"
    sha256 arm64_monterey: "1e79179937d56fc414eb574a8b8f79738e59295598488fe0ef3cd69fe3465dd9"
    sha256 sonoma:         "107602d6caf014813244b10be917d4a0b6734754682b09455b2a4466b89972b7"
    sha256 ventura:        "22a872c5f5972b30ee30764cb3bb48185fa491647e2b845637d5e215b7db888e"
    sha256 monterey:       "fe565f4b70a6c3e25c257c043992bab04f72bb123e113b89297c12abeca6111b"
    sha256 x86_64_linux:   "65c596fce8ccf89f06e3747b3810938803286ac56aaa6fdbdc14fa22a24a74fc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end