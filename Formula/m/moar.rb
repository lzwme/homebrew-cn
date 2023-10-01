class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "56f381bfa113333a28aad6cdb40bf2c81b99338b6806d3ab1039b17df4a676f3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c043ec40a170dd05d077e8753fe63e589a342eb880e3c00c8e05e6746eb55a06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c043ec40a170dd05d077e8753fe63e589a342eb880e3c00c8e05e6746eb55a06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c043ec40a170dd05d077e8753fe63e589a342eb880e3c00c8e05e6746eb55a06"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8850d0c007680025fbe59f021a1384cd0b1565b41fb09850f6c5cedd84c61c7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8850d0c007680025fbe59f021a1384cd0b1565b41fb09850f6c5cedd84c61c7"
    sha256 cellar: :any_skip_relocation, monterey:       "b8850d0c007680025fbe59f021a1384cd0b1565b41fb09850f6c5cedd84c61c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a48e3ce52a74c673341f9fb26c4cd844e49fa71d5ce7c90377ae72165248770a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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