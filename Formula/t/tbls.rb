class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.83.0.tar.gz"
  sha256 "1ed49aef2415bc014d7fd236e3f0ccd414b6676c7cfd6508d1dc70166715fe84"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be19bec79061a6aed8f6f6687f17507b56660b2d6fa2256c1c919a2270cc2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d03b7b8b6a6384be5a7fee456f422973fedc51f099833d8a55ab2e24b10f89db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af82e6d5117b0b7f470a5501ae8673932129c555ffa86bb8e254ccf7061be7ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ca726c7791d4f768bfb817d24ff716cba0c2869a901fd589323ddbb04475efa"
    sha256 cellar: :any_skip_relocation, ventura:       "84aa4ba7ae591cde4f69f52317791077be62452b1186c54b13d0b4fe8ba6ee4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944e126e2ab343145824e85117274ce3c2362abaed5d4f121ba8961e4898d850"
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
    assert_match "unsupported driver", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end