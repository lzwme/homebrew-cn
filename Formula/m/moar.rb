class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.23.0.tar.gz"
  sha256 "1b1731b65d5dd32324eca826efb6f762d79e51b7dae7bbfc8f0e5460f8d370ac"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4851b934802d045aa8e304ae51d387faec96ae3d3e8ab23d2433bb403ce884b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4851b934802d045aa8e304ae51d387faec96ae3d3e8ab23d2433bb403ce884b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4851b934802d045aa8e304ae51d387faec96ae3d3e8ab23d2433bb403ce884b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0445ca6fd887040b50665bd30ec4a245eee07cb28035e5bb61d884f5d118848d"
    sha256 cellar: :any_skip_relocation, ventura:        "0445ca6fd887040b50665bd30ec4a245eee07cb28035e5bb61d884f5d118848d"
    sha256 cellar: :any_skip_relocation, monterey:       "0445ca6fd887040b50665bd30ec4a245eee07cb28035e5bb61d884f5d118848d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e08bcd9d4876e7c2f9d1565eb0875e8f7051687641f5715db97f5ae6397b9a63"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end