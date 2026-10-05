class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "8cc523d204d60499adde4573442612bebc70f6c3bbfc2f75f9c8c42523e67fcb"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6440e14d4d02e0600d680793f931d3f0b025eafe71c7f8a32cd68dbfb248c044"
    sha256 cellar: :any, arm64_tahoe:       "c3f8fdf25bb94149a3b8d1bbf96e5ba3f22cf9b7cd2053b2b7527d13d86c2a96"
    sha256 cellar: :any, arm64_sequoia:     "5a663cc0842f181f117736ce745b64f2fab3798a94e963b553ccb86648683a21"
    sha256 cellar: :any, arm64_linux:       "e021d83d3a10f3b91f4434e33c43faa9352ff3f479bedf9037e8634efa9fe39a"
    sha256 cellar: :any, x86_64_linux:      "faf99c7e58f97c40d75873b07ecab9c9e958ba897bf51a9c3e812ac02c7d9a11"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
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