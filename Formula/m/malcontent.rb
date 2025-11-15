class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "2329a42c4c06f550dc9989dda65dd0e069eace33239221d72203c922cd0593b1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95d84b2fc9d2e88ca3fd81718e5d5746a785aa97ea395784ffc97b82daea9618"
    sha256 cellar: :any,                 arm64_sequoia: "afd05fbccc4ab897bfb84ff096bd41e843e7c236e32c958cb015003d2c23e0c5"
    sha256 cellar: :any,                 arm64_sonoma:  "21b801c3e612c2683b499ad9b51fd8e16697dd7e968fad092de8de47dea96fe2"
    sha256 cellar: :any,                 sonoma:        "6f85227fa008837a5fcbaca26bac3b9c6af747ec890aae114c7c5d2bcae10ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33676d28c571700059801b07e8a729f738038c6258ab1d42622ed92dd9e8d959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad8f957e45529c1c97845a7d13ec20039d69b14b140ba8d7a0526a1c7292a85"
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