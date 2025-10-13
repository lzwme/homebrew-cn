class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "52b42419e565e2bc2aae0b3cbf4b4e6539e8a7daa5ba97c5384982e6fb8c2f40"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac1abbbcae8cd7c3cd655474bc1dee3f4b5bba57e8dc50aaa65144f5216a31d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac1abbbcae8cd7c3cd655474bc1dee3f4b5bba57e8dc50aaa65144f5216a31d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ac1abbbcae8cd7c3cd655474bc1dee3f4b5bba57e8dc50aaa65144f5216a31d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d241aadb14970b70d9394b817cbb29c2e177561f2fb8d41d9d8d0d714da46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c29446716c06ec95ff5d6259d8518ad89b483df258715a50d9dfb79bad29907f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6bfaf99e30ec6e3acb277b18391d9272e64ee02a34c0437dedab08604bb7e3"
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