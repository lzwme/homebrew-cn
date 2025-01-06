class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.31.0.tar.gz"
  sha256 "741505c48342778a4312b35f75b2c87e6d6149e4909f2e6a29d80e9e86c4e91c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4e4a1d80eb193ce945a3322cf1174344db35af7f916527bd958167f3074018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b4e4a1d80eb193ce945a3322cf1174344db35af7f916527bd958167f3074018"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b4e4a1d80eb193ce945a3322cf1174344db35af7f916527bd958167f3074018"
    sha256 cellar: :any_skip_relocation, sonoma:        "749533d1aa66318e242d22906fa95c33fbdc22772c3c14c37ba741b255c2d23b"
    sha256 cellar: :any_skip_relocation, ventura:       "749533d1aa66318e242d22906fa95c33fbdc22772c3c14c37ba741b255c2d23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b00cef489b196ad041600754e2a73c98ddf7adc1f9ee31b1934f078ecee142d"
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