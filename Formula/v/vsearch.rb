class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://ghfast.top/https://github.com/torognes/vsearch/archive/refs/tags/v2.30.2.tar.gz"
  sha256 "f4c244d2b48637e9a42325901b832ca5b6522cec8e2006b0da2aa9b9a0b5e699"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f754a1aca15f1131e3d6198f39e8e41bc468f14b9135536e49978649f7de042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c212154910c3e44cf2628457b93531bae8c3c90860c9e18cbe6457319ec39a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3bfa85db5787be86264db54cdcc32437585d4cf22630a084adae941de5fbea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ab1f1cf3a9035939fcf5c8b8da0c97e4712b6c7f2c486fb7965618cb03530a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896edbeaf740c11a4316f602d3d175105ba1476e557b4929bf0f9ad928e01dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e79843c6873beb28d859d73bd64884c63f60488a7803dc38c422da7f6663cfa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"vsearch", "--rereplicate", "test.fasta", "--output", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end