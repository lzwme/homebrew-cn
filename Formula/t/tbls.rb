class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.74.0.tar.gz"
  sha256 "8478239f2af8c88bb27ae0c924f5220f3670eff76fccef671d2f90a9653e04b8"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4067fb68665ec560b66d52d3d6a93a5485649e00b81d753f27420a1581a2821a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cadc54caa10ff984cc70eecc56428c6f166dfef2d5eba850d524c199e3f891f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f816d32127afefcc85ba279f463fc606b0679869efaf02cf43d16c3c4e63ff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd7fd0903c149a7aa8ad0e09466bbe49a3c4fad9a05ae21468a18ca3b90027db"
    sha256 cellar: :any_skip_relocation, ventura:        "b08ce72a6357824c269f9bd9fc0d88bc91a83f3d19b99b1e83319d699856c22b"
    sha256 cellar: :any_skip_relocation, monterey:       "849dcae38cbc367f42655b08a7f5473606ff5d03b544682c03db1af6f27edf11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b119ce14084a8077d8a952bccab44ea25add749e7b3ed3bd01d73fda746afc8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end