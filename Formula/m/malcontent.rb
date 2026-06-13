class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "6a72c0071dc2e9f4379a5dce3129d2ce1fe880de0c7f80007e058c8dcd7cb9cf"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d72b5eba0479af4b968de12746f0fba70184b4c82fbf2af250be12e76e05be5"
    sha256 cellar: :any, arm64_sequoia: "b82c279f30157e519f1f9add1be3c9095fdd321eb4302b1488daf1a5972c7f73"
    sha256 cellar: :any, arm64_sonoma:  "8ea9e94db67537c02d898b6cde994a3a32ffa2d83245491765c5079112ecd241"
    sha256 cellar: :any, sonoma:        "bb882f742e0d641abfb2f7250e3abab9ca78e3df2e3a055790ccdb0936927f80"
    sha256 cellar: :any, arm64_linux:   "2be07734c45ea37c9b4f6d24b723c168c08b7f43270cbe2cc37a660eddcf0c43"
    sha256 cellar: :any, x86_64_linux:  "a2f307c7895d29bb2a2e912b0673658b57115e2646812c19abcaa1bde5627a8b"
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