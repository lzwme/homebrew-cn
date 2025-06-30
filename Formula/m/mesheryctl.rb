class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.112",
      revision: "583f2669637ef37e25cec6bb905c2cd8593ddb18"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e52a509cf769e7d486197fab94e53a82b35ed562e0d82eac9a8b021b6e4b583f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52a509cf769e7d486197fab94e53a82b35ed562e0d82eac9a8b021b6e4b583f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e52a509cf769e7d486197fab94e53a82b35ed562e0d82eac9a8b021b6e4b583f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e411f805c9b16589d0133efd653dc6dc29ee57a2975b0db294acd91517d22b"
    sha256 cellar: :any_skip_relocation, ventura:       "f1e411f805c9b16589d0133efd653dc6dc29ee57a2975b0db294acd91517d22b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e1519538ca81652752e5d6ac888c21be73e686e6f01b19901b08e3ca50d398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c73ba24651f00344186fe88c8b39e3b72a03781632bde7290e9b268361778e"
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