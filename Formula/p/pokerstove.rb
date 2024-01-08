class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https:github.comandrewprockpokerstove"
  url "https:github.comandrewprockpokerstovearchiverefstagsv1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abb1d6f96017e472394a6af2852b0c9469cfab61958ee90953848e8049a569bf"
    sha256 cellar: :any,                 arm64_ventura:  "fc842f452161572ed767fc68264d8bdb2bf6e22c49fac17ddc76ac2e6f2e4e80"
    sha256 cellar: :any,                 arm64_monterey: "a0f2e8d16940a094e5206dadeb619a8be65232b7fac6c32d8bdae74ec9faca5f"
    sha256 cellar: :any,                 sonoma:         "ff0b8674ac91f4e6b5e7abd6059d7d1ebdd6d56d11c32701cbf61eeca1a027d1"
    sha256 cellar: :any,                 ventura:        "3fcd1fe53808add41cfc2628fb4e3d4b1f4e95f72d2fe2414e305a7e704aeea9"
    sha256 cellar: :any,                 monterey:       "13c612e544191e25d14de05895ea140efd639112d9a3e13f922662d7a5ab5275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4092c63b1302da7aafbd72a4d644c4c52a7bdf36347a623bb8068bd47532c0bc"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "buildbin"
  end

  test do
    system bin"peval_tests"
  end
end