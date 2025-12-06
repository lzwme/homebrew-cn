class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "82dde7e4a4cdd51b367c08ae391b1ff72a0d52676ffcbd027036abb227a95c28"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80f0df080ecf8dba5e1593824ff4486c1b5d4ad989213865eed2f06a190a8c7c"
    sha256 cellar: :any,                 arm64_sequoia: "6fba240d6aeee4b89f31f0bdaf497195d70940264d9f5185b1971e8a289ceee2"
    sha256 cellar: :any,                 arm64_sonoma:  "893bbe0a4dc3c6a4bb3a7f4abdae524645e5c2b791841396b57790cc75873980"
    sha256 cellar: :any,                 sonoma:        "2615256680766a49ef79ba8c75e6ff572f74b24220685c96948596b6c77577e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9443944688cb00d3e2f0f4297ddfeae169ff31519d8550de7daf6e7f1478a2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aedfafec9e8a31852385764018ca8ec14b9d1ee8d9f17ba369c9e76b4ae8ba3f"
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