class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.12.0",
      revision: "8f549d6af3d3109e69dff6ee8e8bf0c1d16453e7"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a17e1599c4d94a94b0f9b133929751d15dbd82b81c8e57cddad509e22fe7608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a17e1599c4d94a94b0f9b133929751d15dbd82b81c8e57cddad509e22fe7608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a17e1599c4d94a94b0f9b133929751d15dbd82b81c8e57cddad509e22fe7608"
    sha256 cellar: :any_skip_relocation, sonoma:        "061834b39564fa77f452cbf69897f945adbc86a22829a32833a2d3abb03a7f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f15c723250eb196264092b4cfa667d9fa9dae2d88ead0bb9ed8142dcb0863858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8cfe3d0d3ab0b0c1ffbf209872d39da85009d67d29c2a68fbc36243fbcbbfb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end