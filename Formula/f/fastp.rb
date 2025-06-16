class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https:github.comOpenGenefastp"
  url "https:github.comOpenGenefastparchiverefstagsv1.0.0.tar.gz"
  sha256 "cd8ba4bbadacadf22a8dd83445455717689a01c774a0a0c23cf36f7a05496c91"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abf213d067a6e80c8058042527c5a985514c4b52ec6e5b43f877a99a35c611b4"
    sha256 cellar: :any,                 arm64_sonoma:  "50ccc67d66768d2dd24a6b83488f928d1b7e288b9d5bbf4a9c748fa58b0637b5"
    sha256 cellar: :any,                 arm64_ventura: "ac172a82c29a53312a39423b66b3ac7ac935d0c93fbbec87f392f5b7ecad4de7"
    sha256 cellar: :any,                 sonoma:        "5c0a2e8ea04344f2247039f59cc93613a9b12e91ceb623e606c5c9524f6391f6"
    sha256 cellar: :any,                 ventura:       "e024e174932a8ee69481892e69ac54f146527b406eb5b89447d3fd1dc9a1a26f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ecea2fb766c29a9cdc93d6c056448c3b1a328c34d50f12455f79ee9389f53b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5279e5aa2abde6a63b3422e42d7ec9aa753d59cbd0ccff68163d65ea71ccc96"
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