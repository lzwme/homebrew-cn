class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "ac581f8cc0bb7970bd5a78ae745cdd9e4a193a6fbb79d7d98fcd8b6e970c4f29"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40dda72eaafe04a618789c2bb54543ca8efeefcbfba5c4d170f1128976a9be49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40dda72eaafe04a618789c2bb54543ca8efeefcbfba5c4d170f1128976a9be49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40dda72eaafe04a618789c2bb54543ca8efeefcbfba5c4d170f1128976a9be49"
    sha256 cellar: :any_skip_relocation, sonoma:        "1edcb0978cf74242a339e3ca892f5663c3370cdfa37cb9f273af6b4339b14f71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1f3929a871206b51850f4272b07c61480c0c992b64bee2641677345ee882ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094c9e649366c345062941dde3adf27b7ea0cfd17b4c0b3472919b7586b9a155"
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