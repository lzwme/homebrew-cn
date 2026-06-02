class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "83412ba2c03d399ba54b4fc18db05e1e9c29d486148f3a2ec3682f3959a0c4e1"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6d5eb207de3b7b3005679ad872e810ed7e8d0d5e578f23b222867058319bf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df6d5eb207de3b7b3005679ad872e810ed7e8d0d5e578f23b222867058319bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6d5eb207de3b7b3005679ad872e810ed7e8d0d5e578f23b222867058319bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe24fa8f8de5a3989cba536f9e2a74ed4e0348cc29b9dfb2ae86d59056bf3719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0bc7d6675e2101974f690833759d0dca86b2f501390ed1ffa1d3fda6c7f764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed67f15f698dab993fb93937cab4da505c9e6cb8f2985a20312b27f7353969a"
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