class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "7d63459797e91be18fd80e31fb9424ee331236769b5443a773501f0be1ae6047"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ec50e30b20ea22020217ae6b6d92167afcc3b0214ae749b6381fea7520e13f78"
    sha256 cellar: :any, arm64_sequoia: "7fdd138bce2540602541c1a6495c3d7a7d6b1af62ac7e5cf933922b5dc44b089"
    sha256 cellar: :any, arm64_sonoma:  "cc4b58fe7e01ce056b3013e878493c3f6c6703f82b946e6ea7d9f56e1e23b006"
    sha256 cellar: :any, sonoma:        "b23f8be075ada88833d4c04966662aa4e4a958b945f647b8c5b7f3967c32160a"
    sha256 cellar: :any, arm64_linux:   "09a74fb9a2fcfaa79b2c500684d461f72d665a597eb7e32bf6cf874fcb8f7783"
    sha256 cellar: :any, x86_64_linux:  "32a2c75349526fe557a07fd69833371c14bf2c585b7e8ad6530dab091b80fe51"
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