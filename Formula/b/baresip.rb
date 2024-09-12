class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.15.0.tar.gz"
  sha256 "8618cfbdfcf80013cb4cabff413b9ff8a5db52fdf692fbf27a53133c34039d8e"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia:  "743bcabd0ac2ef5ed30eb97c7e9a8fe560f4454935f53aee2f127b11eba0eb4f"
    sha256 arm64_sonoma:   "64a39acdcf404375d86d58d4cc1e9d8110a4386e587cd3fc0544a45a733f45dd"
    sha256 arm64_ventura:  "59364d7e3a8b2af467f083f9c10ff7c043eebfedc338468dc9b795f7dde19a45"
    sha256 arm64_monterey: "b0e7396f3ef0336ef7b028489f9d233e62722b4afcf0cff9eda64316eb20a778"
    sha256 sonoma:         "6667056046247d7fb4f1b8eb1782b44742cc105f0253260bd84fa1eb3da5ea5a"
    sha256 ventura:        "20f82613c1d577a1a923507c443df43e2fb614bb63a66a33a750de0f47ba5289"
    sha256 monterey:       "986e7852ef76b06fb5aadb599a661296f13c463e6e037b2936b7d40aae28c246"
    sha256 x86_64_linux:   "2a2047e97f15d6e6342066396d2677cafa37448dbe0be2d5b3d0d652b839ba2e"
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