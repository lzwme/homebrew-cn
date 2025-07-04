class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.14.0.tar.gz"
  sha256 "c92e0e02ee76b5a74ae779b2cf1605c1ca39c1322c71df8ffed667c3108a42f4"
  license "Apache-2.0"
  head "https:github.comchainguard-devmalcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b46759965b0273d98567378a334d7391c3b6166e1917fb9c7acd740a8f3c86f"
    sha256 cellar: :any,                 arm64_sonoma:  "7e3a539273f05409f0fbd846f917d2ad0f395e1d64e3f383e7b0fd04749e8c8b"
    sha256 cellar: :any,                 arm64_ventura: "aa5df47393faf15a409caf48348252a23b534a7e64df94afc560fbb3da60dd91"
    sha256 cellar: :any,                 sonoma:        "0b1251558314d522bd3b8b8d51f513ea5adb5daf9045db4e0cad43bbd55d1668"
    sha256 cellar: :any,                 ventura:       "1dfa7d445e069745c72ac2244736dfe247a8aa1cd33b478a13b528dba8573aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da589be0463ea7986699a43bdb2599237b60af83b9e74fdb7911130429df9611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf4a8b7c1154b273ef5f694687639c59004ef33633003f0eff1f707a493eadc"
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