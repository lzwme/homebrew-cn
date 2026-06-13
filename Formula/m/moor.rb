class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "7bcb4158373453779574b3de1e7f2689513d446cd9d73f846bfde9d242eb245c"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9b1b0f722c549289e958ac8e90c5d61d847cee41ca189396d8118affa71ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b9b1b0f722c549289e958ac8e90c5d61d847cee41ca189396d8118affa71ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9b1b0f722c549289e958ac8e90c5d61d847cee41ca189396d8118affa71ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd57f7843ebf89e26c23a2e56903a0e0ec911ec790f15a93a0a230138efd71ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ca266c74d1d5015e28ea40723525177b3ff381a6402683d8e7c171d6f6b5dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c3549d91c0f5b55981298eb89621a741706b0754e84c62a1c72a0c4b518985"
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