class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ed0b0b7497f1a54c001a332766ff850d7118d9663913f95f3f437f3094f583b4"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951693811983871e458ce0cf7695d290f857335d0665784ce7c42b331eb024dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d35c73bc473a96d87e016988ad556aeb2084bcb039ff3124ebb99f10a2ba77c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c3617aeb496851b7aa4d233f2be85cee9d238d812a96b89312e1ca824f7fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "602757514a2a54029dadeebb1b8ac4556fb55b00e9e217c31d34acf22bc1d295"
    sha256 cellar: :any_skip_relocation, ventura:       "856b03c0900af45c30c254c563f4320709ba6a710f85176c61994fba72fb5785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9d08897331b91de262bcf9d740e800aadedef3b794e336c64b6323d1f7e027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9097ec087e1c71c7b92f77cc4f94d2724092bf26e349ce7fd6e19f4fe737d099"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end