class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https:github.comtorognesvsearch"
  url "https:github.comtorognesvsearcharchiverefstagsv2.26.1.tar.gz"
  sha256 "dc8513376405fc01ca3742624177113752870b05bb682fe1bf62d190d0a696bd"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "400e672d0663e2707a75fc24f132626a3bebdf13b4e87251bb188e47a902fe8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ade21c5d8c4a68497584e0513383b498716e55467d722748fb6b71faf49483f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9f1738c3312034b42273a49cd77709fc184b49acbb2422560e38defb4d1de40"
    sha256 cellar: :any_skip_relocation, sonoma:         "cda97178459d1348fa5a93b72d1dba9bd961a89cc49af0073822ebf645670b8a"
    sha256 cellar: :any_skip_relocation, ventura:        "7de2d608661529a2765d9278ad2eb04df56f995c14e148a1751f92f1eb3bff53"
    sha256 cellar: :any_skip_relocation, monterey:       "3c02df443c906d8c26b4f2d6950b10ac60df47369070577683905a907401362f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15168395f67dc22313c0b8aee0a9ded7eb9dec16fc1279594433229653112bd"
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