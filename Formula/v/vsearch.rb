class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://ghproxy.com/https://github.com/torognes/vsearch/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "960b9b2693fa20a9547367b585542dae1cc93de78bdaea66d6904f14b8216d17"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1410c0a4c9fab927373ecb97bd1bb33311a044b5b6d6a357ec5e1f5f286eca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3575a4cdc980b9d7e30921cebbf3a11afffcb6be4a04ad3c6b026c1aa436511"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3cd2eaf7a188ec92d0aa5c782f08f92b832945b1afa83f430b23f605359fcf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e322ca71567c1aee21509b81f5e56db5488e6cbb61cc6a5264c8119e84d6ee8"
    sha256 cellar: :any_skip_relocation, ventura:        "7e997861afe659ec43b637996a8fb1edc0d73c6c56c26f4d8b0efe4b71dfd214"
    sha256 cellar: :any_skip_relocation, monterey:       "16d81cab6db5372728b737130b63a9e202c518b36b2888a05a4c57b8e18da7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1e8d80c12edc62c017dc569ffd7442e15d011ec3ff2e9f0aac061c99f8b183"
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
    assert_predicate testpath/"output.txt", :exist?
  end
end