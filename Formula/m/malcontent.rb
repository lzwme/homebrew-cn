class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.12.1.tar.gz"
  sha256 "9f30bb13d11f7ddbb52323b09ba8d4f7a525138134ab5106b5112ea1b35a385c"
  license "Apache-2.0"
  head "https:github.comchainguard-devmalcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb46596f8229930075ee1b584cb8f56160e0d0d5d35debe561a100d4157f5850"
    sha256 cellar: :any,                 arm64_sonoma:  "1eca259e9f8de6b1be362f47349a0c842c6da2f73f751e12b64b35aaab177041"
    sha256 cellar: :any,                 arm64_ventura: "df4c5d2442087d5ca9549c6e3464449204122fa85240ce0a17bb125b01bdedc6"
    sha256 cellar: :any,                 sonoma:        "955b7e75046a2bf2b2edd866e9c73fac2f8ad5c81971db433e0c1766665d26f1"
    sha256 cellar: :any,                 ventura:       "c3a4eededf8f5c5af4f7d06bd584dc238896487972a80a1a616f4734fc057c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac30a7f87aedee4e1f73de2ccb5e1547d39a130046f0149396f02f8e9c621e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6263f3463c66e1db1f88828c9cdbb652a5be7b95eecc1d62cabbad33b63e46"
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