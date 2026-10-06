class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "98c723c33c0a5b11cabe207eb262720b1b8a243f86281ee77fee27f27dc87f5b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d38a76ccd5a9f116663d57bb50a638f1e4bf655bed99f12cc7ba19f6e959cb60"
    sha256 cellar: :any, arm64_tahoe:       "96bb2a5fc2ea270a65b4b2c664add93c6ff3b94d23fbca61387774178f6fbce2"
    sha256 cellar: :any, arm64_sequoia:     "898bced18d39bbfab9ce33f71e69a48ec28555073009f60cff25059ed0cedba5"
    sha256 cellar: :any, arm64_linux:       "047d853ccd2a73c9483ad87750e1e79a0ec2c90d8cdedfd636c0a7e7da05bddd"
    sha256 cellar: :any, x86_64_linux:      "8445e36eafc1a7930517896e19e22f2882c2a1d259fecd45c105425bc69173ee"
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