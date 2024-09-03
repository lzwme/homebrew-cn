class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.91",
      revision: "407298429caf2514852ccb246306b6db91d55595"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b7aaab6d4160a8b7a41425eeaff6f0b2f68bb30f1ee1a58187d56152e81632f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7aaab6d4160a8b7a41425eeaff6f0b2f68bb30f1ee1a58187d56152e81632f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7aaab6d4160a8b7a41425eeaff6f0b2f68bb30f1ee1a58187d56152e81632f"
    sha256 cellar: :any_skip_relocation, sonoma:         "95159df657df21476f05553727f69b77621a2696a529494612ddff3b8d929527"
    sha256 cellar: :any_skip_relocation, ventura:        "95159df657df21476f05553727f69b77621a2696a529494612ddff3b8d929527"
    sha256 cellar: :any_skip_relocation, monterey:       "95159df657df21476f05553727f69b77621a2696a529494612ddff3b8d929527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f702e0cad5a154ff8289b24b1bf5fc32f3a1f37d8603cad0afbd6dbe79dc5f"
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