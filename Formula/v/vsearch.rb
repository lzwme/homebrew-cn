class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https:github.comtorognesvsearch"
  url "https:github.comtorognesvsearcharchiverefstagsv2.29.1.tar.gz"
  sha256 "a36f175c4eddf1c7ce7030561de52c20d36ddc5ed1f498ee4853c6808f7375bb"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707481fca987e5ad20fdddbdbc9802762d86a7fff2e9b98429da1ec28528356c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e93eb9e4d3246db02e0f3a2004c4cb14ba6a9a227189dc57d17f765f949658c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37474279c7456e4af3e7b4fc884f2a3ee60e1c5fca98477b1cafbd1999e59e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d224a1d3a0616b4bca509db89538dcbd42dd19fd06d12e08cb981ebabad3378"
    sha256 cellar: :any_skip_relocation, ventura:       "e06fa893b23627ead1390e7d7300911a06b3ef003c6c619e802d0d49e27bf406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1a2b7004541656b340b71d50815773a5713de1d19412927a4f7cbf463bd840"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system ".autogen.sh"
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin"vsearch", "--rereplicate", "test.fasta", "--output", "output.txt"
    assert_predicate testpath"output.txt", :exist?
  end
end