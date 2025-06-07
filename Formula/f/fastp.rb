class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https:github.comOpenGenefastp"
  url "https:github.comOpenGenefastparchiverefstagsv0.26.0.tar.gz"
  sha256 "ab5396f448bece92e599e4d3acc48751fc46f0f43333ca271d229aa95dc47c4e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30f8fe5ec8c763eba03044f2f20bb62a8eca26620eb0ad9195773b091418bc02"
    sha256 cellar: :any,                 arm64_sonoma:  "9c240f042c1e56a3e84d73629460c6c329707953c464715a34e28a370865f9bf"
    sha256 cellar: :any,                 arm64_ventura: "b6710ef28940c569e1f92e9b487cb8ba263f3cd9fc28e573cbf3a6290ad44bce"
    sha256 cellar: :any,                 sonoma:        "561e9820f5f479a46c9381f6355e5b6853be164b0c061b56bb0d121d487b4555"
    sha256 cellar: :any,                 ventura:       "c02b28fdb8341a69540d917b5ace9e4d0cc9a204d548b0fec7e853c0af2a3b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37eac38ffb62670556e02c579d69ecc897d10f2c0002a7cbdb53b5e1dc676fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80b2781db100abda8cff247ec05c2448dac9ef0af2bcee95cc1553b43e4a017"
  end

  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin"fastp", "-i", pkgshare"testdataR1.fq", "-o", "out.fq"
    assert_path_exists testpath"out.fq"
  end
end