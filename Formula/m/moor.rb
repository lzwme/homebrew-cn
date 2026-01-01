class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "4ff5c674cc21758b528adc33e0bea955c3a897e8f0e901f7a1d806a793a068ec"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a07ef9b2707fba4d473f10bff4944696ef47999bf1029afa3fdc8655ae0e3136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07ef9b2707fba4d473f10bff4944696ef47999bf1029afa3fdc8655ae0e3136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07ef9b2707fba4d473f10bff4944696ef47999bf1029afa3fdc8655ae0e3136"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db5d224f04461d3884928089cb02007a4ba2db355a6bca13a992d4c7755edf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f38c5e67fc05cad8e543dbcf83ecbd201999372be8dd3b7628bfc9fc4c9e777c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be8d1858e48c8d94ad39509868962a5973bbe659e1fa02941556c491713278e"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end