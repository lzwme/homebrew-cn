class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.69",
      revision: "822160e9dd535b617a23f2b6fe80a05168eb95da"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5977b918669f752aecd6d06c38650928254e52ee49469f7d3dd2801c528ae42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5977b918669f752aecd6d06c38650928254e52ee49469f7d3dd2801c528ae42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5977b918669f752aecd6d06c38650928254e52ee49469f7d3dd2801c528ae42"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ecd0e65b723f2a1b4bccc9a54a5facac1ec46e332e6023f5559dcb402cc2566"
    sha256 cellar: :any_skip_relocation, ventura:       "0ecd0e65b723f2a1b4bccc9a54a5facac1ec46e332e6023f5559dcb402cc2566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c06f9a174f98855bd6a3e925df20345821ab7a65fb3a2bd1f352aeb864ba84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6ba5008d1984f86fee371125942117e28b50b865afc2e6ecb08bdf595d1025"
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