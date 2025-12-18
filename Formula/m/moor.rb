class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "86b58a81f1ca10ee2873c3618c4effe447fa76bc4c89eaa1f0dce1d32dadff9d"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a54b1c870ef5d855e3fcbfd3abf1b0cab206f0d384a455d50be4aad0d5bad18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a54b1c870ef5d855e3fcbfd3abf1b0cab206f0d384a455d50be4aad0d5bad18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a54b1c870ef5d855e3fcbfd3abf1b0cab206f0d384a455d50be4aad0d5bad18"
    sha256 cellar: :any_skip_relocation, sonoma:        "da47a9bb0e1859fc394064c990db1b10f64836c6b2fb94a3a70b9f61f92c1c1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13eae1de4cbec1582504eab9142a4e4e52f78eedc45223bf58c6461cbde6afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0008958d98f9e1ebc94208ea3f399f25fa057c6eba3ecf0b27b4552439871188"
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