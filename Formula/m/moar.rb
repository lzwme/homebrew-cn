class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.25.2.tar.gz"
  sha256 "8f6e44109be12924ec6cca073c9eb9d51ed9c7c2384eb71622d2085a2d558ade"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef41ae27d485141d5ec27948ec7b160bd325644451d6049dfe65b0738891a305"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef41ae27d485141d5ec27948ec7b160bd325644451d6049dfe65b0738891a305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef41ae27d485141d5ec27948ec7b160bd325644451d6049dfe65b0738891a305"
    sha256 cellar: :any_skip_relocation, sonoma:         "e249cef22a41807c570dd1e5b642f2415344f7e0719ccbcb0352797f9cd2ae67"
    sha256 cellar: :any_skip_relocation, ventura:        "e249cef22a41807c570dd1e5b642f2415344f7e0719ccbcb0352797f9cd2ae67"
    sha256 cellar: :any_skip_relocation, monterey:       "e249cef22a41807c570dd1e5b642f2415344f7e0719ccbcb0352797f9cd2ae67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b3b47622253c3abd2d5c61fda25929344640257e13546f38fbd16fc356f367d"
  end

  depends_on "go" => :build

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