class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.93",
      revision: "18991ab134150285171a2f0987bef2dce7813867"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf19a76b55f672ce745792d5b30ca608b7275523716eeaf645933df21083ee93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf19a76b55f672ce745792d5b30ca608b7275523716eeaf645933df21083ee93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf19a76b55f672ce745792d5b30ca608b7275523716eeaf645933df21083ee93"
    sha256 cellar: :any_skip_relocation, sonoma:         "52283281279c63624d0a037bbd0cb30ce911d02cfdf108307c53f6087ac991df"
    sha256 cellar: :any_skip_relocation, ventura:        "52283281279c63624d0a037bbd0cb30ce911d02cfdf108307c53f6087ac991df"
    sha256 cellar: :any_skip_relocation, monterey:       "52283281279c63624d0a037bbd0cb30ce911d02cfdf108307c53f6087ac991df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e87fcf1a7a914dcf771c79f655fd27c10cc445b0cea311fd4732b98864f992"
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