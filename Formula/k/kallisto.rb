class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https:pachterlab.github.iokallisto"
  url "https:github.compachterlabkallistoarchiverefstagsv0.51.1.tar.gz"
  sha256 "a8bcc23bca6ac758f15e30bb77e9e169e628beff2da3be2e34a53e1d42253516"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "952ef6635a1537aeb609ea82597d95e6411a5cf351e5916a5507acf833f9fa0b"
    sha256 cellar: :any,                 arm64_sonoma:  "bd9eb12bce6d33e5640a0e0c0fc3f76f8f68c4732e09e22398740132d42af405"
    sha256 cellar: :any,                 arm64_ventura: "1628bb7528f5118ab8a2739b279604dd01fcb6b1175e01fc6c93246e5b6a62eb"
    sha256 cellar: :any,                 sonoma:        "872bfc8d27e0c9d83e7c35e67904492807acae02d145d79491289cd1f343fa91"
    sha256 cellar: :any,                 ventura:       "368d851057292860af1245b39a7daa8ec873a2bcd64fdc8a6bdbf5186d1f53f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85a57db730f00c05d2adeff1493065baa6d23480bd36db9ca5f5e17634f42b9"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "zlib"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build", "-DUSE_HDF5=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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