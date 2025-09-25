class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "6e53c47ed2dafff4605f904dc881e88ddbf09e7c1a6bc13c0a6f12d3bf5b4bad"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ce92d4e136c8989f181620a7163c540a0ad3df8478ce4832643bc2e60dfeadf"
    sha256 cellar: :any,                 arm64_sequoia: "0a7d606a39715bc329f78643b3fc23cc6cf84e58e5d7ba71a482428de1800a16"
    sha256 cellar: :any,                 arm64_sonoma:  "10a4bb735877cd7742d8862bd4c9734cf63d2cf0d23ec98ccafd41f0ac313ac4"
    sha256 cellar: :any,                 sonoma:        "32ac6cb6bca6ac6a2983391268322d7279860af27784e4371af9895dc475e74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144c20a0caf0ab60574ee4152a72c2dfef9fcfc4b218ff1d16a320a405b1915b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "905c648b06e94d5f6d14f1eb8a80f174888f512d48a4ad5ff623e1e16d475c90"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
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