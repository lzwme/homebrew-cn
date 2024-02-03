class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.28.tar.gz"
  sha256 "be418bcad52acc5e4097682733673307849b663ca5b1f34efdcf0e0bf4f5b374"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0c217969d001bee7bb239a7d5374b592ed110e9e09d0543ddd3641a3bafd485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f1d262ccb1459cb59bd526608b471740fe5173bacec96a446bc64a8d72f5d8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "873b479a8d5642077a17955bcff591ed8dbc6a82ae7f1b036f34a4d119659897"
    sha256 cellar: :any_skip_relocation, sonoma:         "9399960b2122353eefe171712d2ab8f0f288ecbc6547140bd30f23a01d0b49f6"
    sha256 cellar: :any_skip_relocation, ventura:        "27afb91a4900642bafb4420ffb03c0c96c1677ca562e8cbf2b6333ae5d4dea91"
    sha256 cellar: :any_skip_relocation, monterey:       "bff7b0a27aa9c1598dd648e35438c3083b68746106306168f2f3c719dd9fb04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe608c92868dda5afacaa3d6b491461e083a54118e3999acee5f89550d59a2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end