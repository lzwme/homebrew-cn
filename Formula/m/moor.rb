class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "818e19048913cbccc9be893ee60cad6bd977e7ae958e2c6b68007cf67eb079a1"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cc6b398e991cb486a8817362e542a2e26e6dcf0e4d536f67be6388964ce5f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc6b398e991cb486a8817362e542a2e26e6dcf0e4d536f67be6388964ce5f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cc6b398e991cb486a8817362e542a2e26e6dcf0e4d536f67be6388964ce5f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a458cfb03ae27ad4f83689034eacd09bcd8fd1cf7840c49b8656b31c7afc9e69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219ef83be93ebef19e0d741d4be61aa1a26d82fbc08cce4860846748200a0904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366ad8070c104e910253a3e24f8a165efab18fd70d9fcc34dd6e7546d8ab7dac"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-X main.versionString=v#{version}"
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