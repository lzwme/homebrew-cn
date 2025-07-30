class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.123",
      revision: "ba761472b7577a78deebeaa6e4d14ed97e3aaecd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ffaa1e5b0accbd1461ec84420fd112d1d7c4b07d5cb2594eebc1269eae86ca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ffaa1e5b0accbd1461ec84420fd112d1d7c4b07d5cb2594eebc1269eae86ca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ffaa1e5b0accbd1461ec84420fd112d1d7c4b07d5cb2594eebc1269eae86ca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "034da9cbe387ce592cd81c526fc18a871baa8f76210a8d6a81a19f48fd9e890b"
    sha256 cellar: :any_skip_relocation, ventura:       "034da9cbe387ce592cd81c526fc18a871baa8f76210a8d6a81a19f48fd9e890b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e3641fcc45ab1c8d31fde092d663de2e0e0a379451f24de24a19fd10dee2228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c481258cb0a906c1f951b4f63267e7783a18f64494dc9424fa659d6e7a19b6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end