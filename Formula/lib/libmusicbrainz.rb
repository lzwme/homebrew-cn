class Libmusicbrainz < Formula
  desc "MusicBrainz Client Library"
  homepage "https://musicbrainz.org/doc/libmusicbrainz"
  url "https://ghfast.top/https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz"
  sha256 "6749259e89bbb273f3f5ad7acdffb7c47a2cf8fcaeab4c4695484cef5f4c6b46"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ada38db81da84d8fb85cae7dbc30682461a1d198556fdb01d9be05fcbe9059f4"
    sha256 cellar: :any,                 arm64_sonoma:   "62762e1b184d0c47bb287e151333dafaa526b733ea2c4bd5fbd097d987b84aa4"
    sha256 cellar: :any,                 arm64_ventura:  "f94dae2c20f0394e6500176d823845716fd3696e692527e8106542e7d3a7f392"
    sha256 cellar: :any,                 arm64_monterey: "fc0659a30defd25b9d1eb98acee0c6165d3a25c013a7a5bd4d77247af9096ddc"
    sha256 cellar: :any,                 arm64_big_sur:  "cd8eb4a4a2aaf1d9328c3b84439f16996b5e586d1069edcb28d4dcf8c994a30e"
    sha256 cellar: :any,                 sonoma:         "2b9d6fc49497521a3518c7520b4a82fc153d6f9ed187747a13c2bc561b8a75e8"
    sha256 cellar: :any,                 ventura:        "4d83f20fe8412445dfe08de416eb711164ea7a1b5495511ce5979d0d2a40c9f7"
    sha256 cellar: :any,                 monterey:       "26b5aa846f4cd2cef477fa4e60b3f735b18eed3451528f2517a8de9ab38d0be1"
    sha256 cellar: :any,                 big_sur:        "a03a79657821636633079121735346d0b50ac66ab13e7a0da695b4f8e8499464"
    sha256 cellar: :any,                 catalina:       "3ff30e82e933e84fdaacc2a0d8c568678adfabb0b7771667cbcaf07132f59a14"
    sha256 cellar: :any,                 mojave:         "420d6867aa3d20d9148d4546a154e7059467cc4ca8d861dfb173c9ea35f10dab"
    sha256 cellar: :any,                 high_sierra:    "99b598b941ac0ce3747d8821943a1e730f3673b721421d9c0428b70259e789c0"
    sha256 cellar: :any,                 sierra:         "8fe055e1f987e23a569f915082031e172a5c3d0aef6f86de78ce9c8258f53cd2"
    sha256 cellar: :any,                 el_capitan:     "6a63410ca9eae84b263d7165d05701801f4e05de26a9e95a7396f95a602cedd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a233e5f068712c01e17c57f8055fef4a9c42f6184287d69fd65b8760bf51d15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9a39724adbf24eb1dd5b25478d8b571be9f8fdc42d6249696e0934e07a1e4c9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "neon"

  uses_from_macos "libxml2"

  # Backport fix to build with newer libxml2
  patch do
    url "https://github.com/metabrainz/libmusicbrainz/commit/4655b571a70d73d41467091f59c518517c956198.patch?full_index=1"
    sha256 "ee0c63e56a17156bca13b157744a54aeed6e19b39f65b14f2a5ac4e504358c8e"
  end

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end
end