class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://ghfast.top/https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.8.tar.gz"
  sha256 "b1f20d254026ef59110af39c3dcf2d915235a9a1ec52d7bfd21739c66666767b"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c96c396d7b6e94d012da5721505a62db2b5b066d717716b64115756fb3f117d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c96c396d7b6e94d012da5721505a62db2b5b066d717716b64115756fb3f117d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c96c396d7b6e94d012da5721505a62db2b5b066d717716b64115756fb3f117d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda367572cfd694ab4667a462a3233ff3c99376003f7d5696074050d564d0d2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3713ae4e8fcb6b9c47ab4f515d51080225b7bee73a6e5a11dc201508ab75feb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed793f31577e0600f039a5cf4afa71469e38d3077d5cd86138d364532e4355f1"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end