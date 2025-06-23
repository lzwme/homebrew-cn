class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.108",
      revision: "a7e901480f2df9ae07675b544394c38e9b13fab7"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaadcca75a9a314383bc78fbef8567c6eb6b68ae65f5052a7e3b83b3203d7215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaadcca75a9a314383bc78fbef8567c6eb6b68ae65f5052a7e3b83b3203d7215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaadcca75a9a314383bc78fbef8567c6eb6b68ae65f5052a7e3b83b3203d7215"
    sha256 cellar: :any_skip_relocation, sonoma:        "335e09ce340071188717366456bb5dd17a30033723555579af564cf97fb303b0"
    sha256 cellar: :any_skip_relocation, ventura:       "335e09ce340071188717366456bb5dd17a30033723555579af564cf97fb303b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "642ac73871c15fb91c5744f61f20319fc30992cc9b84d5d3d433eee6a2d664de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f508f1c2f54c3e204c13c2b3db082426f583f9f2ddc47f0b95924df257084333"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.commesherymesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.commesherymesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.commesherymesherymesheryctlinternalclirootconstants.releasechannel=stable
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