class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "ad5cd21d4260fe2bb86a0b2f25511b810efd95f195a39969049a94350af3dd88"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f0e06d9aa7365dbbb3ccfbbb70b660aec3c13ca0e432ff5f78badfb47ecd2dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0e06d9aa7365dbbb3ccfbbb70b660aec3c13ca0e432ff5f78badfb47ecd2dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f0e06d9aa7365dbbb3ccfbbb70b660aec3c13ca0e432ff5f78badfb47ecd2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b69354bdfa4608a0fd549324d9ecade5974da6cbafb05266491f5fd8c6b5ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50b575179857ff7822be3971ad27fe110a54227d07914af833d2a3ca429e2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5993cc29a2c1653839f6ac1269dbf141bc2e0de1893f24a52267186dc5a49896"
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