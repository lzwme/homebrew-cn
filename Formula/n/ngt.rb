class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.3.10.tar.gz"
  sha256 "d0d238743f6af56be26949493e154dc6d1166fa82205149e06a87955961e7007"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89fa3310d00e21269a179102bf390ec1f15651185a6bb9849c86aefd116e4c19"
    sha256 cellar: :any,                 arm64_sonoma:  "a0efdd8cc0bd5487aa517a28b1ae58f52fdd27dec3a7ed615e0f415e4d7cce16"
    sha256 cellar: :any,                 arm64_ventura: "315af838e8279d90f9d6727a0a558ff492153da85e48774fb763f238e21d61c8"
    sha256 cellar: :any,                 sonoma:        "9fa90034731af3452271fa5c892193382cffde6ae81b499026253da58e3ca71f"
    sha256 cellar: :any,                 ventura:       "206303c4a422b100090a3c932c32c3a1643b2e048fb40afdb2cd7b7c22ab03e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca0ffe3356f788465c6a884518c1b9a9d3a63b761dea7cdc23bf77690a5ba43"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare"data"), testpath
    system bin"ngt", "-d", "128", "-o", "c", "create", "index", "datasift-dataset-5k.tsv"
  end
end