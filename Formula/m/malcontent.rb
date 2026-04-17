class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "bceaa411a255d3211bfe7c8d8c0e6fcb910663db52dfbe47e82a1f89bfbd73f1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08831fa8566786b304e3f8f492126da4abc1bdda10cf66470cfc5e2b12bcfebf"
    sha256 cellar: :any,                 arm64_sequoia: "f2ce721f793c22d447e029616d462afab8e69af8681dd87c9223db95388cfdb8"
    sha256 cellar: :any,                 arm64_sonoma:  "5f3c642d651865ddcb0017f555656cce3f5d7d1497a96ed1cf19baaa48078685"
    sha256 cellar: :any,                 sonoma:        "b994dbb0b8531048af7daf44329cf32bc25304b857963bfdcdc4699311187e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c045cc652135452b90de87f68b579fe98e41833be852f18d1e7609650b528fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eaec359fcb24c36e4aa0db1616f11938b3c00f97879fc472a82c7e7c85b0e72"
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