class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.64",
      revision: "143f21682e998e9b3e8ca3d41825126f412dd2dc"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c31a530c3fa9f1731194195e15b3abd9694b113592f6c3a52ad2efb4046f580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c31a530c3fa9f1731194195e15b3abd9694b113592f6c3a52ad2efb4046f580"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c31a530c3fa9f1731194195e15b3abd9694b113592f6c3a52ad2efb4046f580"
    sha256 cellar: :any_skip_relocation, sonoma:        "94cd303b16e7e22e8e8d6ddaf67438f5d5b8f9a37db3769861c0d6bf5d6d7b3e"
    sha256 cellar: :any_skip_relocation, ventura:       "94cd303b16e7e22e8e8d6ddaf67438f5d5b8f9a37db3769861c0d6bf5d6d7b3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43be129f64a009046cf0f7e9b532a170b416ad252797e838f76b3c6862cb48bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2956fbc0913252221fcf153607ce4c241a0ef1bb7542132f836c084f4887f0b0"
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