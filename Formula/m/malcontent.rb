class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://ghfast.top/https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "8e939062e753d33131ac64f754533ca6e8a002711c0241403c1724ad93350acf"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a24932180a78777c993b5ac4379da4651ba49083b8a130d796bbe7a03b1f0c8"
    sha256 cellar: :any,                 arm64_sequoia: "9db22d334129236bccd794bbadee86f4027270661f04b2ce1a6ce8ec69ba6fcf"
    sha256 cellar: :any,                 arm64_sonoma:  "adb0a041d24afa3861ca97465355d8ea37de3f73e5fde590a48c5a25e837354e"
    sha256 cellar: :any,                 sonoma:        "5090cf43e9f1cbf1941b2f513e9285a065dad9703fd84058061a2de96925ba57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d9002e3dc49878eb93ac0cbd1bcde9fc02d68b75765f0e68b08d1d1b8b53ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abfabb0764b1f21dad1a40200fe45414abc3c56f50e2e1a9a28dcb4e160476f2"
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