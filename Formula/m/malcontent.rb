class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.13.1.tar.gz"
  sha256 "4bd181926080ed9c026cd049d4c92f8971cc7efe21637ddc2809ce232cbe461c"
  license "Apache-2.0"
  head "https:github.comchainguard-devmalcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68b0d5c10a343273509313bb3c379d5cd0404327a8a8a1b458530e3c7a0b7789"
    sha256 cellar: :any,                 arm64_sonoma:  "e1bc20b6f44e57e235e3e93b46409148b2368289d0539ed8ed83c9f7dfae114e"
    sha256 cellar: :any,                 arm64_ventura: "94b7f0bc1613c14dcdb888b503400fb01dfe7ed7401584e9c6fa698c3b961513"
    sha256 cellar: :any,                 sonoma:        "2e62ec3f066aac4d5094d711f7cc5ee17f9f5997e0f83735b1aedb3db4a18204"
    sha256 cellar: :any,                 ventura:       "44a1e02522a68a9a8dfb4ddeb762fada07c052b3ddc824aee99677a0fd864c84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "292cc289ba649274a84420f39526e3965ace48e1d48e687c8f502389712c95cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6dd118196280e59937cb102a4e491c9e895751edf615b85f1d0a65aebc6525a"
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