class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://ghproxy.com/https://github.com/torognes/vsearch/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "b7e25638924e56591d7c6ac3a959795000439937f5b566be7f06457bb31f91a9"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "719b91593edb9de3fee6e12bd95c5b587c0f69378ef736a7bf38097de140cd4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f709c104eca2933c10f2773a423880601141887a02fc24e928c46fbb9091836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4bdb5500697e1149e42f80969c7d93087d48c2a4d4432b4b7228920b4ec265f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9a2ab3c3c43a6718af7844b44ed2cf5d841e36cc6dccd9b140d65964a9ae091"
    sha256 cellar: :any_skip_relocation, ventura:        "4193601355b8a630c15ce99996f5c9229a47d4b7ba63234c758e2af138d93d7a"
    sha256 cellar: :any_skip_relocation, monterey:       "69fb100327204b76e3ae2b79f8cdc6299c8dd6e29f0f517a8adaae116e25f858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc5099778555abfa80b88919fa74e6352062f2713a5b163bf032ac10587ad4c"
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