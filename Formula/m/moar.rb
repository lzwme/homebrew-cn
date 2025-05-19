class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.31.6.tar.gz"
  sha256 "f25f48a7e98aae566bca81c191e21307a46e61478696da6c74b50b84d162e967"
  license "BSD-2-Clause"
  head "https:github.comwallesmoar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328788c08c55e5d89b31680860c2b56583a2adc3a13057f670b999f68b5c31aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328788c08c55e5d89b31680860c2b56583a2adc3a13057f670b999f68b5c31aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "328788c08c55e5d89b31680860c2b56583a2adc3a13057f670b999f68b5c31aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab7267d756847929329aee391f208fb232a627035e1cfb2124cd7150f90540d"
    sha256 cellar: :any_skip_relocation, ventura:       "aab7267d756847929329aee391f208fb232a627035e1cfb2124cd7150f90540d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a10ca9ebe41c18908be8d9cd0e3d32a8c80750e12867e573fd3033b799097d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f8eb37b5e013573075a07ca29e72c681974fb83a4c2ed05b8fc52fecffa1bb"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end