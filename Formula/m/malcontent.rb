class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "246c6aede4ce35623231d9b4f11442dc10a34c38f812e3708e6ab9e3ca275983"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07742b731b287296554a1c32d709043ebc050d1e68a839f963a0ebfb0f1f8bed"
    sha256 cellar: :any,                 arm64_sequoia: "0ff5e03d24f8c4bdd8eabcf91b53f676ac5ed4084b801ba994da7f5dd238fcd7"
    sha256 cellar: :any,                 arm64_sonoma:  "7f3ad079f6eaa328d10f0b3204f263ca6f4ba418246fdfc192ef7f7a2d583bdc"
    sha256 cellar: :any,                 sonoma:        "95ac08e94f70a4fd70a43ac8cc0ec72a98255b5595a5fb9f901e5f3aa54048cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d479f197f3e8b4514ba1773b455aaa47374ebf7c161da2be889f499a965754c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049557fa8d23c0acc50da8cefe51033293b04bcef63b3d0ade235502f57b2316"
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