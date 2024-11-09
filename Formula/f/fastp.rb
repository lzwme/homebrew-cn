class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https:github.comOpenGenefastp"
  url "https:github.comOpenGenefastparchiverefstagsv0.24.0.tar.gz"
  sha256 "42445973c57be9209c753027e99781261c69381013813c576ad447e413ff3d04"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3ab9145befee1c91f94affcbff56639d42d51d0ca15968a77a03fe8f3470e34"
    sha256 cellar: :any,                 arm64_sonoma:  "84d99c79412d7d1d4a7d0a28ce5c053539a0ece96d9895743c164231b88fbdd7"
    sha256 cellar: :any,                 arm64_ventura: "c95133f539e6d2028c1dcfe77636746afc8b5cae83f62149e30645aecec8319e"
    sha256 cellar: :any,                 sonoma:        "2fb9b68f0f5e6394ef0fc4f2e9f3f727169276d7036a8c5bf46b26a99680a5f4"
    sha256 cellar: :any,                 ventura:       "7280ac0a603254ac8711bb1de17acd0c22fdc067de3ad806e3e74fd60fba439b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9af0aa2d7c574f3522b4ca8dfd39df425f995f0b9a09e7a3fb63adee9a5ff6"
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
    assert_predicate testpath"out.fq", :exist?
  end
end