class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf/"
  url "https://ftp.gnu.org/gnu/gperf/gperf-3.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gperf/gperf-3.2.1.tar.gz"
  sha256 "ed5ad317858e0a9badbbada70df40194002e16e8834ac24491307c88f96f9702"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d97505fe5faa03ede1bd71ef14066f582dd8fef9bcf723025799f976f8298653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b404e102145be82f33a5e84a6e56c910f4cac3aef912f7a7f802f20356e5c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34ec83f71714727f3255f8c13863f34fa68c8f0f70a3422efcf54836eda5d11b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede60d33e45555a7a5ed0fc5ae31d9abfd7015d31f2b77f0b1d2648690a48f92"
    sha256 cellar: :any_skip_relocation, ventura:       "11b898d27b7082aca30954471c125ea865d3fcf99c71bf2258b4f5d323473b92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a64fc6bf8562580034d3f9727770a7bd176ccc3abbdb95672c6b923e7585890f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1a6861bffd2ac71f31a9e1f511d037acbffd8b2a5904146c621fe2827d90bef"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output(bin/"gperf", "homebrew\nfoobar\ntest\n")
  end
end