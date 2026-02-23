class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "e7ab25e6cce597d9442d02f9abd7241ce1b11b20cc89d1e701537ce7f3229e22"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abbf7bb168bdbc3845cd46b85c47ca7912417b80333b8edb3ad57a011f4bbf79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbf7bb168bdbc3845cd46b85c47ca7912417b80333b8edb3ad57a011f4bbf79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbf7bb168bdbc3845cd46b85c47ca7912417b80333b8edb3ad57a011f4bbf79"
    sha256 cellar: :any_skip_relocation, sonoma:        "62ba97aab4cc8793e3c8ea603ba16609f85e9535f1dfddbcd32c42f8dcf8ef74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae8a720577f0aa19268ae4e6d03ad25d72b9b85f235644027a081bc70d26fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948e0fe8b964b001056f58856d20247d7e658434339376eb04c5c3c316fd0933"
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