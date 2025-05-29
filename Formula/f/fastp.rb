class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https:github.comOpenGenefastp"
  url "https:github.comOpenGenefastparchiverefstagsv0.24.3.tar.gz"
  sha256 "fadc9068847227b8cba2147d0202633fc16d85a91f7457ea94f7931bfaf91f58"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7666aab28dcd81e8787fe44ba32f8519775f03ea0e18f7b3f1e5fdf3c7b3a63d"
    sha256 cellar: :any,                 arm64_sonoma:  "ca39e9bea75256e12223ca6ef23c0490eacf1143a140e65500bfc7fd071905ff"
    sha256 cellar: :any,                 arm64_ventura: "e47a95ee7fc76480ce484a42e8bb063587beb80d3290f53a20ea10ef5b812056"
    sha256 cellar: :any,                 sonoma:        "eff7597aa3ea003f19b8cd2713b93eb7742d965b0753bb84510e5ba41827846e"
    sha256 cellar: :any,                 ventura:       "af4c2c4e78a4ecd8b71b96ebed0d5d7f674b78ceefb199aa8db53b08ece460e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14a7f0aafe37f6ff064238a91e0e7948e88849c530567ae92995eb2be513558d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35f4ad2700ad7e0afc0b7fcfecf1b29785aef99e6104df020d46afef3521bb1"
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