class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "c8a24ed7dca47f02f996ea1a820bb5fe4d9c6e4c43c6320d3a1a10914ced4f8e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e75427c566d2cabb5fe3b94ee51b0f59d99c15b2c6fc4c8168d92b6fa3cba642"
    sha256 cellar: :any,                 arm64_sequoia: "9e8e0a6f6a1120ece44849a5613703e909a6e9a7d8dd9d808187d37d7c305717"
    sha256 cellar: :any,                 arm64_sonoma:  "78a5fb6b8b7a044968b8c170848902061a6a8b37c4a7405b874286293cb616a1"
    sha256 cellar: :any,                 sonoma:        "e24d14a8b999685e99eeac1157b5fc0b119bf9137dd181cf46c828c4e671a1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3691b34727b3dd929227fd1808222857be156d2fe1a93bd427fbbf8cc0174548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c0df57f13c115a2c14e7d72334f7c8413b0b417113f211a86adc3cf44ddb235"
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