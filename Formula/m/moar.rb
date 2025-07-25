class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghfast.top/https://github.com/walles/moar/archive/refs/tags/v1.32.6.tar.gz"
  sha256 "888e3df2ad915a5f10daa9f1122397c4ac94863f07299063e32da5824fb2ad3d"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32daa025c694e39ab758b5228ccd8bc2470b47d2f98db334c239f431ed68ab11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32daa025c694e39ab758b5228ccd8bc2470b47d2f98db334c239f431ed68ab11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32daa025c694e39ab758b5228ccd8bc2470b47d2f98db334c239f431ed68ab11"
    sha256 cellar: :any_skip_relocation, sonoma:        "486248075f63b1e5e020bed872a5e4247217c1b498b9c1cb581ba048a5831316"
    sha256 cellar: :any_skip_relocation, ventura:       "486248075f63b1e5e020bed872a5e4247217c1b498b9c1cb581ba048a5831316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f739ea9a745877b9dbcefbbd2f94cb3b9dcab587303c136d62e4aa59faed51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca2378c91d42c357839940cb97fdc7ced62d630909f7314dcd113b0a0be16aba"
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
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end