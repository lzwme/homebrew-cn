class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "2997a2cdcac26f9ddb7f05f05e3885ae9bc45896b2a2a8eb00d333f2d36a8979"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ad392d3fb48eda09fe935705659bdb7e3d7a64ea267b93f5cda707281401b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be75372ae6024f5cdfb65f4b566b7a8dbf67d6923f0d83122a7e18ac839c57e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1b9b8b4e7a6e587353e773dfb6a386e2b0e2bec3a40b3214a12c05ed074eb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e1dce91b157e10e6ebe59179fa1eb8fe56be1bdd0c232c7804ffef87cd58b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8338f5dd037545494cda880d8f787bfe26f05336135f4681822d7346d52f3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d819b89ba79111a494e146a09100015658beb6236a32501d1f9637083a215d79"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end