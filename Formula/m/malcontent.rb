class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.8.6.tar.gz"
  sha256 "282f46640dccfe4b254ae4d0025e983ab8d0273c177966512523e988c0a4a13f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21e574522d3c15ba2194dea95c7b8fcdebad8c38f215cca35fcea387ff7ccfec"
    sha256 cellar: :any,                 arm64_sonoma:  "15bae21aa368c40552b76e177a9e93cb4cc92debece18f3264ebfc122a0a3fe0"
    sha256 cellar: :any,                 arm64_ventura: "0ab802e01d203cd0ae28a066c5e26209976b1010049271ce140728b5b659c819"
    sha256 cellar: :any,                 sonoma:        "bc8b0999868c1bdd49e5025f9bd54c53cf3e0d7f68760ffcc9a4c3ae86148389"
    sha256 cellar: :any,                 ventura:       "13aad75c87e25237c28cb0f7d4dbc5cc031cdbc95dc96ae90656d14d4f25ee98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d281303886d09f7bc59704f8e4ff9f02a4925501f2cbb723a9df38657b5028"
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