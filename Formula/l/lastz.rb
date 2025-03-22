class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https:lastz.github.iolastz"
  url "https:github.comlastzlastzarchiverefstags1.04.45.tar.gz"
  sha256 "cb7d971915f59089341e7916139a98a5da94d724de21c7eea8baa0a0bdbaa7e8"
  license "MIT"
  head "https:github.comlastzlastz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ce031cd09d74b7ae2ae82d9a9189b32e3df8433188f7eb612447a32b9bea42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6e2d5edc6d4c169458d5ff27e6a3b8340f470f15a5b82a8f59ca19e72c1f44f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8ba0e448acf38b7da9a386ddfbef6ee8b3bde7a7e0aa8c5232ea0f6e58c7e74"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac376ea25d1996a6d8120d11aa011f640090c783726178e4f69c82f7aadffba1"
    sha256 cellar: :any_skip_relocation, ventura:       "324119d3aab25c48c04efc5243964098ffd65164363590d146f375107f73bdac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637aaa2b65bd47142c86e17825e9812349d557b193fb97f4a500ebdca69180f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d679ed18fb5c5e9cefd794abb3654dbd7bcf76f89420e9ff98b1716679d5c3"
  end

  def install
    system "make", "install", "definedForAll=-Wall", "LASTZ_INSTALL=#{bin}"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}lastz --help=formats", 1)
    dir = pkgshare"test_data"
    assert_match "#:lav", shell_output("#{bin}lastz #{dir}pseudocat.fa #{dir}pseudopig.fa")
  end
end