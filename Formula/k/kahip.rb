class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https:algo2.iti.kit.edudocumentskahipindex.html"
  url "https:github.comKaHIPKaHIParchiverefstagsv3.17.tar.gz"
  sha256 "3aa5fedf5a69fd3771ac97b4dbcc40f6f8a45f6c8b64e30d85c95cee124e38c3"
  license "MIT"
  head "https:github.comKaHIPKaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16093791788ca776629995486830135eff95a1f5a811feb83ac76e426594b54d"
    sha256 cellar: :any,                 arm64_sonoma:  "d8857629b507b827fa310597072e62f0a4343616a4680b4ae7fe63c5ec2d20bf"
    sha256 cellar: :any,                 arm64_ventura: "138f4b644a0798b2d5db48b41de9552cd7d8a96f7d7044884e3c2740303c91e2"
    sha256 cellar: :any,                 sonoma:        "0b1b0511b0ad243ae8d009eebf326918d0a17b930f2e7eb38ce2da64a28e8224"
    sha256 cellar: :any,                 ventura:       "4116ad27663b45eefb02d97d6b843c2bb4cbd9198ed2c3d0020b6a3f1a5e7b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b023f1a6c42b2bd9edf696ab8e345a067d8879c6e6df04325765de9e9c5684"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "needs OpenMP support"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}interface_test")
    assert_match "edge cut 2", output
  end
end