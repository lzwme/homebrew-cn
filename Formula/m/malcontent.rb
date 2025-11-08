class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "5a3221a4e8c073878e84b76be7063424d449efcdbc2db1c2108ef0ec317ef650"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d496694907816aff4239db592ed15b47d4122552d3678958e108777b15ed022b"
    sha256 cellar: :any,                 arm64_sequoia: "a5eecc601071b7680b789180684355a0ae2a496f99b6a823640ce972bc8de4c4"
    sha256 cellar: :any,                 arm64_sonoma:  "7b6fdfe80a4955da51d7da87d9130ad9197e9efcee7df41745d6d797402b2631"
    sha256 cellar: :any,                 sonoma:        "216f29b30c95d55bcaba1fb715ca1ee6f0c1cfe1531b1272e474105ff85dec1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "821c056c018499414aa91090c44037d0c3f34333cfc065435f7ca19c204193fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db485f6854457e08915c23c8d2fd5f983d736ce843cab020b1172e85a0c43180"
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