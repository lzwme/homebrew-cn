class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.93.tar.gz"
  sha256 "83f2176cc6292b43cd988d2cf763672a290801ff90f945a50d632f001ac25ae7"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f2c5d4d20fe500219caee479692505144dd2aefb69da73231ebcd222dbb4fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec595b30e853dd91f723098dbe1da6e2c040ff5439de176248d196a23dc37f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c6b62c3d2932049f701367d5689de183d35063eb00b2fa1aa818f8a3ef5bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d0eccab79718f13c03ec91a3950a7b375cb52ea404465ff9f800f4b435573b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c3a297f24a0bd7c4b334e0735cb7f53855acaa9808116b8306709c4c9c367e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8535afd2511eb2a34bce6fe7b096e343794771dff6e608d5772c0a0d933422"
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