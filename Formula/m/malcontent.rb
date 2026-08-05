class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.8.tar.gz"
  sha256 "7dda58163b1b1e9561f70b5060c61b14c185c83fa81b4a6b94b6e45a55daaee9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c1341d0ebd55057d8383a213ce56a458b20d948c9d8825c57e7d985ded59b7ee"
    sha256 cellar: :any, arm64_sequoia: "4400f01da2801640ec1231bace00b021d333a02318874091e916644270bf70a6"
    sha256 cellar: :any, arm64_sonoma:  "7a15b95fec801519545c7be8d3631d650ec3d3411751577791d2d0b83384ca63"
    sha256 cellar: :any, sonoma:        "5116e116b568e99f4f07f871ab7f701813489d6bc954a948aee15a7762eb7af4"
    sha256 cellar: :any, arm64_linux:   "947c5fe6e003b8d478e9c1abdd39b4e214f8f0c00043cef41389f63bb12f69ca"
    sha256 cellar: :any, x86_64_linux:  "402144d66c0896e2a4cbc0bab767268e52e8dfad25ba86ca1c771759a102fe7f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

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