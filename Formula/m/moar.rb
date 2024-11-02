class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.28.0.tar.gz"
  sha256 "6997b8c675950481793fbdcd6d0bb85b887901865031136a8135ca3cb28b1dd3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40709b3485bed8954874df74f8fbe321b4da5be263d3b4120f6dd06ff68e3cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40709b3485bed8954874df74f8fbe321b4da5be263d3b4120f6dd06ff68e3cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40709b3485bed8954874df74f8fbe321b4da5be263d3b4120f6dd06ff68e3cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa010d08b3c41726e2b9c5fb62787c41b291261c749277747d082375fa52305"
    sha256 cellar: :any_skip_relocation, ventura:       "ffa010d08b3c41726e2b9c5fb62787c41b291261c749277747d082375fa52305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e331d604b6266885147fb67cedc41f613bfb877b410f78c5c8805e719a5651"
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