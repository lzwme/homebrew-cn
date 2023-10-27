class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://ghproxy.com/https://github.com/torognes/vsearch/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "036c3a5c7827958446e56155d750d22d03d460a53237c37fa6541208dc0bdca1"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f53d56538f64077455099a888550f22e66dbaaeead8da61a7b16da07e04fc5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a80624fe72c241965d82420a8ea4538c23af718fd9d5f894a0e506451f271242"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b57f9bf306a124a85f87cc275b44980b3b9a055c2b7f65324c08d56c596c204"
    sha256 cellar: :any_skip_relocation, sonoma:         "5aab8ac1922fac9eced0c25a075e00e94125cf0104a7d1370f588cf9bd0a5a82"
    sha256 cellar: :any_skip_relocation, ventura:        "d69f34f54cee5bb5df7e2c0b758cdd9c731f99f117b680429b5abe9f77fe2161"
    sha256 cellar: :any_skip_relocation, monterey:       "0a07f2641883f5692affa6908c7f4d4c96de3779a8af8115d912050edd9fc940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be10a92c6bc3238c9a3bbe0b54052e24a133bb9152482ce4167c496cbec4c360"
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