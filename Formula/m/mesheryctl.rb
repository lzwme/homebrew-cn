class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.11",
      revision: "fa40f6302ee47f3ecd8157d74c9ad855a5e300bd"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b8a71cf2815d602758a7105d797040c5b3947f2c93b386a476b2733eb2f3213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8a71cf2815d602758a7105d797040c5b3947f2c93b386a476b2733eb2f3213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b8a71cf2815d602758a7105d797040c5b3947f2c93b386a476b2733eb2f3213"
    sha256 cellar: :any_skip_relocation, sonoma:         "8207e9a03e23ab00950c6263ae84fe3625e6fa7e945ea786d37e204efe9d425b"
    sha256 cellar: :any_skip_relocation, ventura:        "8207e9a03e23ab00950c6263ae84fe3625e6fa7e945ea786d37e204efe9d425b"
    sha256 cellar: :any_skip_relocation, monterey:       "8207e9a03e23ab00950c6263ae84fe3625e6fa7e945ea786d37e204efe9d425b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3cb2ca3e06f0a114f622ab152408b9ce09cfd8e9c9a879a27d661ecb64f07cf"
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

    system "go", "build", *std_go_args(ldflags: ldflags), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end