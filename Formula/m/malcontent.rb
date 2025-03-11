class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.8.8.tar.gz"
  sha256 "8237a49ff067469c1e29a5d020e8c2a2d08bb6b5122826d43fa4aa96b0407003"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f9826278ae01cdfd7a33d72059b898517b10885f74ea7600de19fe1509bc34d"
    sha256 cellar: :any,                 arm64_sonoma:  "2fde26e76d32c802cbf6b47a6df9dc245dace3ad7f405bb1282384ab1698b539"
    sha256 cellar: :any,                 arm64_ventura: "292c95f0f2f0fe45a35d4f2554658ed8b43d8b66536d865e91b4c284e624aa68"
    sha256 cellar: :any,                 sonoma:        "88d21d680798ab9238095cf09fce13673fa021bd7e90cd9bd8659c3474faa8ff"
    sha256 cellar: :any,                 ventura:       "559f16e8f755f6268b43708737cf840dc3cf41831ffbcb6aa716b7e7a16ea01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04805311b1135528b8046327207486b02afd55856ab3ac4c94e68ccbed54870c"
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