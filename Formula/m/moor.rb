class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ac6f99ac2dae2aeba5aea56ba79045968501b3708bb2b673e58d7d6118af8309"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eeec96a72ae6b737945a0fcee47b4b50ac5717ec508fb5c10641d9ac80d2b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eeec96a72ae6b737945a0fcee47b4b50ac5717ec508fb5c10641d9ac80d2b4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eeec96a72ae6b737945a0fcee47b4b50ac5717ec508fb5c10641d9ac80d2b4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "421344405701d798fdb01406b4e35f35807409e06af8d061f536c971287977fe"
    sha256 cellar: :any_skip_relocation, ventura:       "421344405701d798fdb01406b4e35f35807409e06af8d061f536c971287977fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4049fc6a8a067996961a64039a4ff9083a8de74e87da9e578e09636faed3f7"
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