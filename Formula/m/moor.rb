class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "091a8bba0d75354c2897029ae89604f47c63d1670ce32f4f80f10b99612dc584"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8679ee57e8f3384a37c730e7adea4c853e0f91c703df001c348317b4d2452189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8679ee57e8f3384a37c730e7adea4c853e0f91c703df001c348317b4d2452189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8679ee57e8f3384a37c730e7adea4c853e0f91c703df001c348317b4d2452189"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0241628f65147d9f93660c18f56837e6d251c315342bb8b38cfbf3534d3d910"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed20cd5ca0241ed2f72939fcb45558eaf9911f50c9608ac621e6b912698b6449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813ccc4818a05a7231ad0108b5abe100beca4210cdf23b382cad78fd0d933001"
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