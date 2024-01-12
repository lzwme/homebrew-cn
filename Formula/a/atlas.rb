class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.18.0.tar.gz"
  sha256 "2d7a889380caeafbc318e25bc67a8acd8921a0d345a9ef0fa590a59c64a676bb"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12623d29cdfe440d9fe700be560935a812a97b9f165a83577d3cbb5c2912bed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9bde547af0f335c7e4ef4ebc844f49f2e91e1fe303c3dfeb37a2bf4f577a356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21da01e75ffb6580f853ce1cb9fc24a55256fee79649139fb8d63d743126777a"
    sha256 cellar: :any_skip_relocation, sonoma:         "363056e328449d95df041a6d273f0e58309ba48cf70233b5828cc22b65678151"
    sha256 cellar: :any_skip_relocation, ventura:        "cee5f49d1eb9eec1a07f79765d3f1589a6c777ffe8c43b3d8365e8e04b9be5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "e50afb5c2e8fc13d251072e155692e7ef8adfa2bd01c8715bd4a429a5069faa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7a7bc1d6dd7d074e99e07201fd7a28b2ed19bd850d9a92fe138f863e3a0c99"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end