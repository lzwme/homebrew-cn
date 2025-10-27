class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "2b9a26b7000a92778802138b92bfe6134723e2c72ba1829ca7da04efd314620a"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f99d177d8af47cb376610b7f0a5f323e1add348c84a6a81a1d403bb9e5ffa42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f99d177d8af47cb376610b7f0a5f323e1add348c84a6a81a1d403bb9e5ffa42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f99d177d8af47cb376610b7f0a5f323e1add348c84a6a81a1d403bb9e5ffa42"
    sha256 cellar: :any_skip_relocation, sonoma:        "136039043c71d39264d8365d2d31eaf80869fb3698751194a3441aa6b1dfe320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b20f261cb876859d2aa4ba6356f5bd35a7e3a5801c36672b10fa071360bf633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f526a1abf0f84846b5d99ab3652f71bdbffa750ea03a2e7dfbadafb6e448b2c"
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