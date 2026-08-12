class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.16.3.tar.gz"
  sha256 "4416cb3e2019adaf8b99cb4edd16c1d1821ae7d224188b16c1cbcca4ff3534b6"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865443110a5030f783430efbe0c07f4e0b0aa6a28d0b409d50bc594b40926e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865443110a5030f783430efbe0c07f4e0b0aa6a28d0b409d50bc594b40926e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865443110a5030f783430efbe0c07f4e0b0aa6a28d0b409d50bc594b40926e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "8abf4c2f3fff4299b2a2bf84ef3f1dba11f499a30588b0e5debf3d9be3b30cc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e771e690ea48d26734eb37d333ecb4f9045c7c699ce3daf6440b51cb22e5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8cf4eadbd4831a3b931bf8226a3fa9b93b462dead199bfe5bcf3774b7420bc7"
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