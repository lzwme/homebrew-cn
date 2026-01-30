class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "9877f66f9f2ac65418ece6fc9b61e347243b56eaffaa38d4bd87f7769053fba2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "080f0335c77a628a742c09f574085e6994cac85a5a3b566fbad869d232126dc8"
    sha256 cellar: :any,                 arm64_sequoia: "3527ae70d21e806b14831b6c329b11c839cd8075a9457dc60eecca15a0fde400"
    sha256 cellar: :any,                 arm64_sonoma:  "e75b025ddc406b3e1c63159e92b9c25720b430f32931207e68c9d7c77ec7123d"
    sha256 cellar: :any,                 sonoma:        "8e472d3fcdaae47ba63acc0d08f044b57e3793f104f2045273de7423885a1b78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14d379f685e6a86119bec1e52eee42887339371f8c64f2ec467e2c0f4edaaf90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a049933d3de6b01cf53ecb5109ddeb8d46c10588df908ec9dcff68fbb364679a"
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