class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.12.0.tar.gz"
  sha256 "3534a7a4baca5269af7c3db582fbffa5f91674f4f0b0f7b4e9f96595aa5c8505"
  license "Apache-2.0"
  head "https:github.comchainguard-devmalcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe7df86e511474bf27123444db810ccfd34207415207bccf63a2124fd2bba4d1"
    sha256 cellar: :any,                 arm64_sonoma:  "c71b6596af8429397ed73385cf8a855b7e00dcc98cc623cabc125156dcc5435d"
    sha256 cellar: :any,                 arm64_ventura: "147a085df58a6fda35977e113b5bc7616b663415365b4d440f5a25b95a1ec76e"
    sha256 cellar: :any,                 sonoma:        "b832c297996d0dd56e49603b4978b53702bd8e9283fb87d068c56c852fa99969"
    sha256 cellar: :any,                 ventura:       "502b33702f98f7bdb99aee98f89597f083c13fff1a371aa4c6be9c015b0dd7de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "765a6c98bd01f86403a284aa509e3e34c362044e521addd9f01ff6e09a3dc008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3597a2b160fbadcd2a2c588c7a1e5e9809073c77a1b4c9b0550f855329ac2e8d"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin"mal"), ".cmdmal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mal --version")

    (testpath"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}mal analyze #{testpath}")
  end
end