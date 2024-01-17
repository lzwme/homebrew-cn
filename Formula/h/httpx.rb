class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.3.8.tar.gz"
  sha256 "9a38346d99b22604f6134a62576285eb8dcf429019a529f9358ea39a037cef66"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6372145759cb9d6e9d9077312f1a841bbda39b9cb434c541d0c7aba4ae63d484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "987e4043c73e0273b270456fc107daf7aab3822bf66b512d5b2e8873e06465f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71a8bc894962c817cead6a8071baad6ec4b1a199ad6dceb633df57d47c1b349e"
    sha256 cellar: :any_skip_relocation, sonoma:         "696f6d03006cf6658363d6bc893717c14e0a6d13ea9c3e21f030287726cba2d1"
    sha256 cellar: :any_skip_relocation, ventura:        "8fd37d6b242d08240c96009bd14b376b6df50ac9780c38aa4c4e232fe014c974"
    sha256 cellar: :any_skip_relocation, monterey:       "132eb6902f5774f3ef985349f1f8485eb880c426dd2f68eaa55008441590fcf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff04c0d6c19e84f919e507acc23d6afc4acd2af39d5f3fc2e9af7ff99e1c775"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end