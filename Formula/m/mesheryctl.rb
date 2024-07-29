class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.85",
      revision: "102448c21c307bea8f3450bfb170bb3c1d0260d1"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bdb1e3485d911e15152ca86710ed9d04575096889789db5963c0ffad76954d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bdb1e3485d911e15152ca86710ed9d04575096889789db5963c0ffad76954d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bdb1e3485d911e15152ca86710ed9d04575096889789db5963c0ffad76954d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f6e4479ccccf733d957faed9bf967262ee450e83ba95cdbde13b53ae9eb0e00"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6e4479ccccf733d957faed9bf967262ee450e83ba95cdbde13b53ae9eb0e00"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6e4479ccccf733d957faed9bf967262ee450e83ba95cdbde13b53ae9eb0e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d0bd219c6d8f87761e2a5ab14ef0263042d32a474e22fd24cc557b8ec302370"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end