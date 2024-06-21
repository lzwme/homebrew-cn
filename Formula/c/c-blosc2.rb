class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https:www.blosc.org"
  url "https:github.comBloscc-blosc2archiverefstagsv2.15.0.tar.gz"
  sha256 "1e7d9d099963ad0123ddd76b2b715b5aa1ea4b95c491d3a11508e487ebab7307"
  license "BSD-3-Clause"
  head "https:github.comBloscc-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "560470c24983bc0b9117110d9b03e111f407af3bf08ca40f0e6e567e43fe0839"
    sha256 cellar: :any,                 arm64_ventura:  "24e9fa45aac7fee9d8baa411e49b1f46ea15b8ef6ff72cda26222163435d890a"
    sha256 cellar: :any,                 arm64_monterey: "6738796464819ba018e702be2e70718a6e2f35b218f678b351c151d699726cee"
    sha256 cellar: :any,                 sonoma:         "06c21c8975f5a093d0c6fa038e54e234f627cc15b897c9120ce15c3ec0677beb"
    sha256 cellar: :any,                 ventura:        "46594393d5d72f8d27760658347207deecf4839a80371e456a5bc3c6b08cc5b8"
    sha256 cellar: :any,                 monterey:       "38c1e9f005d6a29db1dcda18000e4c48e2c7bac80e8dd0cec3ff03aba2c5f5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f964278fdf432ae0b6898f876c9a05b0ebcfa664783d16de3e0888c1c65750b"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    args = %w[
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examplessimple.c"
  end

  test do
    system ENV.cc, pkgshare"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath"test")
  end
end