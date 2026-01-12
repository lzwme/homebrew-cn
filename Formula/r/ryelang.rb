class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.96.tar.gz"
  sha256 "0cb41ddb75a44692229d3df96bbf8132c22705522538ced6655dc553abe75bf8"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87183477f13b6c4254d1a70829763013a16883ebb377d500b5dbcde7ab758f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf8804b03b533d0e93c086ae25e0f312f9e060c52c5272494824320e5e37789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b13577a91d7b329edb4ac46a3270b1f85dbf3dd69c4f7da21f15aa61f3f3f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cf661645fab19fdd0c562e6fa75b264535edf857846598d27bb9b847e35dcb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324d0ec5f3d72306ac430e224aae887e78e28d7ab757e8bf9401033d0c8b3a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601a5226ee04833c0da056048512417d31b901ce21700b5a83bf575bd4db5702"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end