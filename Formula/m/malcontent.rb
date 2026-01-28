class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "e0480bdf61776cf71f561dd04898068c8ee926927a54d65dae34027b8caaa8c9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e24a5124cd58293d26a591b52b9778b808ee81e8cf74424ba99978ae1632bb0"
    sha256 cellar: :any,                 arm64_sequoia: "2cfc133c656d2f0373b93cc1603a3603343cd2db89b30b59d0419aea7769a5d3"
    sha256 cellar: :any,                 arm64_sonoma:  "23531a89ef14668f56aafa00e42d6e82104441841e7a1ec3bbf72144ef5a45b7"
    sha256 cellar: :any,                 sonoma:        "d91ca2d4c8cf723c66951c3f6c71eccac8784601d6a26abfb8515b4c05d10d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa33fa483f3ba54e7e4f76596e409f49788e67e1031e1690f6e1b7a7aa6169d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a546265c4c725115dd6fb60e2e10456e392507d550ac0cf3bfcaea70a2d4fd7"
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