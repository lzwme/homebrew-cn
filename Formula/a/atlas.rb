class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.25.0.tar.gz"
  sha256 "fbb385185c9c1576c2350d483bc624409904b8ee63db0950b84a4115e991bfd8"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84495bbb62be8199e031bf162c029ce76a3e379a1ab6cec60fc9c168adde6511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6f03c0038c9ff93a878bd9bcd678b9080539a1854bcacabf953436713edaa68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5019c0240fe96183eb9decb0ac93a3fa099702b78a125edc7b6c676cb9c55f11"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e6e906117c19d1f37f030c42327df37fd43b19b82bee8877ea5f8da47e18397"
    sha256 cellar: :any_skip_relocation, ventura:        "a170c939bbcc1767d93aa9d18e959e96b6a0293a8504d54274025b29014a3336"
    sha256 cellar: :any_skip_relocation, monterey:       "d2df020eff949a44b007320aff18ac69d1c58feb9062bbfb6613e823f6236a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b801522e71298b4b65a5e923a23449ef0f2322e36162759dd42cd75f707e74ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end