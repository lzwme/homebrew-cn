class Dislocker < Formula
  desc "FUSE driver to readwrite Windows' BitLocker-ed volumes"
  homepage "https:github.comAorimndislocker"
  url "https:github.comAorimndislockerarchiverefstagsv0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34239da3f2f7776cb63825dbb9aef1f29fa0702926fb34f164ec60b79ba8e8ff"
  end

  depends_on "cmake" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "mbedtls"

  # Backport support for mbedtls 3.x
  patch do
    url "https:github.comAorimndislockercommit2cfbba2c8cc07e529622ba134d0a6982815d2b30.patch?full_index=1"
    sha256 "07e0e3cac520a04a478f1f08d612340fc2743fd492b0835c7fb41cfdb5ef4244"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}dislocker", "-h"
  end
end