class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "9d12679262274f7234cf9b16ee8d52260cfac0b694756218d3a29de89f31a6e5"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28d04ecd3a5f036a262414b6abbb13575ce631896322c1820f5a4852a5166c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28d04ecd3a5f036a262414b6abbb13575ce631896322c1820f5a4852a5166c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28d04ecd3a5f036a262414b6abbb13575ce631896322c1820f5a4852a5166c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c189484289af3cf26e47725e82af068d7252a40318c86429b8a99adc960168c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d969cb09fdfba1d594900c87d4df19d3d1cc751ee009890f1a4033cca47c94e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecf18cb9f25e842028745846375e7b8ff4165c27d23ee1fa6a267edbdfaa0ad"
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