class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "86225daf5ae843a5760c4d0cd68f38c63044acca254c64be44f2d6b0def95215"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69eb1fac4102cb67e259eae61225a8bccd132b8896382e8d4dd268cd65eeb046"
    sha256 cellar: :any,                 arm64_sequoia: "5537e63e4de37b4ad30dc1ccb2ac3b45207f9bbd91eee008d1a47058787ab26b"
    sha256 cellar: :any,                 arm64_sonoma:  "b2f00f07f342a367a3276fab86548b019b8b768add688dc73999f34b93f9f051"
    sha256 cellar: :any,                 sonoma:        "669721b3ca2c91889320446425a2f00558e86df89c6107cf578fa487ce3e1631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfad064db606f59e7628f7e306406944bca4cc148261f850735626e27651082e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f425cb624f8c1cb61a2b032ff352a6b2288343a4b610d2e33de97b51ad3b38f8"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end