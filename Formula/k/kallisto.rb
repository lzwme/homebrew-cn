class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https:pachterlab.github.iokallisto"
  url "https:github.compachterlabkallistoarchiverefstagsv0.51.1.tar.gz"
  sha256 "a8bcc23bca6ac758f15e30bb77e9e169e628beff2da3be2e34a53e1d42253516"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a87ec16d9a8ee8725e6c62d55b425cff6dbaa60a1ac78a9c9af42cc09e398784"
    sha256 cellar: :any,                 arm64_sonoma:  "0b289981fda59f2eeae5c3c595c6687d483f937396df395b6c66d1801dbbb3e5"
    sha256 cellar: :any,                 arm64_ventura: "f4ec21b4a72b069c9c1b27ac8b8d9f15c7e983b48179101eae428a6a807bc197"
    sha256 cellar: :any,                 sonoma:        "549cfd8cf077f6036e208b84e37b7fbfaa65cb9606f6490aa2ed7dbf56dedbad"
    sha256 cellar: :any,                 ventura:       "0c03d4c62821f87a5f356546b45c3b18af91d43f6537e0bb95ad6b594b44960d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8415604e9af3bef4b404268c124db94afd6ccc5c47eeca27c5d5a41012948d7"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "zlib"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    system "cmake", ".", "-DUSE_HDF5=ON", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS
    output = shell_output("#{bin}kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end