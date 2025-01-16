class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https:github.comchainguard-devmalcontent"
  url "https:github.comchainguard-devmalcontentarchiverefstagsv1.8.2.tar.gz"
  sha256 "fe2f34f54aea9ef5a5d56a5b76609e0f4b7b948f6ca1605f6b184be28cddaa40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b816b3d4f0d831c839b1ca427991139755b9b55ad177a5e5f6ef6c67730be5c3"
    sha256 cellar: :any,                 arm64_sonoma:  "5ddba048b2962edc1dfa8bb1de4cb62f2c1b5acc4b2f798a1f85e027133bd103"
    sha256 cellar: :any,                 arm64_ventura: "4d57bc45bb97da819756b9a38054c8796d9f95925e680d205da4c78c7beb8ed5"
    sha256 cellar: :any,                 sonoma:        "7b175eed46a299751df74116fdb85b51a52a190e6cca8d45eeb4caabbf6c4416"
    sha256 cellar: :any,                 ventura:       "e94a6c8d64377e0cf6cc0c4e85f071c28b2c2e3907827198f02ad1cc317178b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5583dee28477d973dc07714712ee3316edbe4d8b3c96fb35b04a3431e38157"
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