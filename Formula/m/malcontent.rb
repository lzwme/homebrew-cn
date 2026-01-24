class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "dd65ea673968ee2185644faa52f088869c0470bfb6014f64e142c3041a2614dc"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34af391691b03c3d87819e8b612325913a5b4185fa287311493e5cdb7bb62a8b"
    sha256 cellar: :any,                 arm64_sequoia: "3817522aa994331c08c280e15b0673464ed4a9baac5ff7b7e150d907e1f44ee1"
    sha256 cellar: :any,                 arm64_sonoma:  "f57296d3685fb070c4b4346c9f6988a83931ed31f2c8497a4b3aa6aab52e3f28"
    sha256 cellar: :any,                 sonoma:        "770fb7097ab1a491349c37d3f3a661d7615270b6c0ebc9a723fd1ca831713a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d478e5a5942ba441168b7e1fdb56988100c0053b9df001fee682efabecf296ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23bc57222c83ce0caf5f83986eb4f4bec471fc4f8e791082e23c5f0097025230"
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