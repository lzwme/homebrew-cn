class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.10.2.tar.gz"
  sha256 "c3ad90b96926d3a418fc4a20c06c872530d9e2783145a83970b83c69ae99bbb8"
  license "Apache-2.0"
  head "https:github.comchainguard-devmalcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "59d9024a16b7a0b4bd3b2d5ecedfb31f8956ad3d54d68ce0c272c41a1cf8574e"
    sha256 cellar: :any,                 arm64_sonoma:  "e4348525b4bfd103ac998080d3e5584ed1013750f157056df73d47bac8b400b1"
    sha256 cellar: :any,                 arm64_ventura: "6d9f8dd0282bd5772c1ff9f4ae79e057b07ff0660f1ed571424f13ff3720098b"
    sha256 cellar: :any,                 sonoma:        "77ab00092864a3719067d2952fe396610f311b704139053ea49f6922d7b104b9"
    sha256 cellar: :any,                 ventura:       "2c88974df740627fabedc6fd9f2c3c57b020b62507a0b2e78ecc778a201f0fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be8b598c499774442b81c17bf73e7200156e4ceaf88a8991c90cb90124d72a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfdf8a607dd09e66add3f3173651300a502d62c82b9dbec1513a61e4b3075e3"
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