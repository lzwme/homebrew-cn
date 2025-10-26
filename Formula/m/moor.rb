class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "c80ef80f4300a9e0d60f76e61fd20b6dc6345ce800005805715d8b95dca4d330"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e173a308b7a7115a69120ec0b8a7a5bb3e1048cb20a42267cb534d4e6a02c614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e173a308b7a7115a69120ec0b8a7a5bb3e1048cb20a42267cb534d4e6a02c614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e173a308b7a7115a69120ec0b8a7a5bb3e1048cb20a42267cb534d4e6a02c614"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a26960d9970bcba155f2aa974bf0506c7819ac1f9e0b6a5b3a062ada7602090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fa8145f2882ecc6c1b431259f33b8fc419fd8d1df6010aae189710f3c5cdc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d598dd49be2303f24d281afbeffcabb5330f900901061240d7a411400db883"
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