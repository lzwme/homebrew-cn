class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "f8a91ae1a169c79f9196e42b454a3346d01b6cf328d0cae0b63054b611a700fd"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c55ec3d904cb291532358c154bb00748b831a894fb5716cde49ca223a4118eb7"
    sha256 cellar: :any,                 arm64_sequoia: "8ef206889929a9ba3147a96391aa9a0490eab0ae299bebfa8a80f4d90e9dfe19"
    sha256 cellar: :any,                 arm64_sonoma:  "8f0a2ff54163e4355e43c2704a811615eb11b81d3d0ce145275234229aa0b016"
    sha256 cellar: :any,                 sonoma:        "66154b30366a2095792a49e8d7872bba9bbc106f4a82cb74dac37caaf522d5cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d107216cec4b095f2e7931a2c3b19109eb848d2a3c6c78ff8a07b60d1ed5374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3756c7b998e7142ebf20561944533accc269e372914ca4e98a17b1daa4f9a2b"
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