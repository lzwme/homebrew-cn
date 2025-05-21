class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.84",
      revision: "6d8b8d6652476b476c394fb3fff052f209ee0868"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b04fc14365c5344d41af958b5d01b4bb6f3649799701aee7739e79921946e9bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b04fc14365c5344d41af958b5d01b4bb6f3649799701aee7739e79921946e9bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b04fc14365c5344d41af958b5d01b4bb6f3649799701aee7739e79921946e9bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0878cc09451f4268b3f5eea6fcdcc838ab2c44998610dda8a78208e7f9fa6a78"
    sha256 cellar: :any_skip_relocation, ventura:       "0878cc09451f4268b3f5eea6fcdcc838ab2c44998610dda8a78208e7f9fa6a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b109ab08cf81b84b0c4d10b371800e9414e0f704683fb983907c2c680ad4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e3866c1c7538144e3a6dcc3de0e44bd2294ac22e571f80a10477262bdb2ba6"
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