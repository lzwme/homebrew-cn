class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "243eaa13e18c029f25ecd075e23e8ed54ecfecc9d1334a018047f262df65fa29"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "930e701d5dec6e88be64b79ccdfe90b21e3c47205537c8cab0fb801266551978"
    sha256 cellar: :any,                 arm64_sequoia: "2b092e38772e321375db24780ceff2589db26db079c2f7544aa66b90a3fec4a4"
    sha256 cellar: :any,                 arm64_sonoma:  "08b1901323081aa029f57a4e2a1d68399aa25e4e6f60fd37faf1943a901ab771"
    sha256 cellar: :any,                 sonoma:        "46fdc4802e832a62107cda27ef68b7a22f6aaf9973ce52f30540fd5dcadfd1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5672568d54dc761ba9d237952605c050ea541c31f443f37108bfda9354e17195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532496183a5c1cd2ba11e171fbd41ed8f0dc9cef3cb5c41d9bbec9a6859c5b6e"
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