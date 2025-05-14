class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.80",
      revision: "061e80bd9a554305b8bbbf8ef00ccf662ec9cc78"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c4381cc91ddfcf182bc205801af01579aaf4199562d4a97aad851af177be95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c4381cc91ddfcf182bc205801af01579aaf4199562d4a97aad851af177be95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86c4381cc91ddfcf182bc205801af01579aaf4199562d4a97aad851af177be95"
    sha256 cellar: :any_skip_relocation, sonoma:        "649118912642456ef29f25f280c2f35f340c2f36400497c82c06d0ec431472dd"
    sha256 cellar: :any_skip_relocation, ventura:       "649118912642456ef29f25f280c2f35f340c2f36400497c82c06d0ec431472dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bc29ec3550d0c21a328a78e113104476659a9e99bbee685075d5f1897cd063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5054426d55f281b16bd512160513923ac16ad7844e3a863c79fcd0cdf55724c"
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