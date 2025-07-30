class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghfast.top/https://github.com/walles/moar/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "1aae66633a1b300e69666555ce8c6c9bdfefded634267ae7ef0a1f58fc2026f9"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7515480e2bfc00d84e42913d48720f45ac30e7929f02fbc49ea164cc5e2e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7515480e2bfc00d84e42913d48720f45ac30e7929f02fbc49ea164cc5e2e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca7515480e2bfc00d84e42913d48720f45ac30e7929f02fbc49ea164cc5e2e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c7fdf81b1b618cbdc230f4848653f85e5bbad0e6c363e131ba2487cb977ddcb"
    sha256 cellar: :any_skip_relocation, ventura:       "1c7fdf81b1b618cbdc230f4848653f85e5bbad0e6c363e131ba2487cb977ddcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc101c93b8fe570654cb524a6ea8a14cc7558802bd19841d9db4e2e891840cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b122024f6f9aa2ddb35203ef3e306b34cd4b6c639a3a2685d623311be25736af"
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
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end