class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https:github.comedoardotttfavirecon"
  url "https:github.comedoardotttfavireconarchiverefstagsv0.1.1.tar.gz"
  sha256 "fda132c912983d0501a99675ce0b546c1782aec0e380b6a2a84d7133befef465"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6d2f2f14153741afbd0c7c8033d4c99499566bb33d5f868a36078c269f93366"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9184bb4019ba01411f4c18d19791803b6d23f0676b22cfe9c1c3fb39a1f052d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07da14a0c9f3b438256915afbcb04f156aedd8f7fc7ff1ac43be746deb4f7d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "488d3fe51bef4f4ba68e097ea77f28dba52776737ab169fec08c54844381a43b"
    sha256 cellar: :any_skip_relocation, ventura:        "b24d540025a3768b4d7f7bcd1bfb1a986a18d8fa371a7b6477952ff0b978a51f"
    sha256 cellar: :any_skip_relocation, monterey:       "17df722f76a6dcb4c2f2f2c168b81a64e5657864905a90858b65c14c5afb522b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd848ee032cf58395365f2bc80decca279ce9eb6c2fa3efc03b75cfd5531e7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdfavirecon"
  end

  test do
    output = shell_output("#{bin}favirecon -u https:www.github.com")
    assert_match "[GitHub] https:www.github.comfavicon.ico", output
  end
end