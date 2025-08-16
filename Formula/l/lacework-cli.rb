class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.6.1",
      revision: "6c4e1305f1ade8121c6ab201f4adeb9388ef7eb9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a0db6057af2e6e33fb45185b470be4c5db70b420ec856470dad0ff1fdf038d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41a0db6057af2e6e33fb45185b470be4c5db70b420ec856470dad0ff1fdf038d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41a0db6057af2e6e33fb45185b470be4c5db70b420ec856470dad0ff1fdf038d"
    sha256 cellar: :any_skip_relocation, sonoma:        "92a6fe929f672723f6f11b5fb4d72d1e9e268692e876128f4a7f9c16f8178818"
    sha256 cellar: :any_skip_relocation, ventura:       "92a6fe929f672723f6f11b5fb4d72d1e9e268692e876128f4a7f9c16f8178818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989afd42e0bd2515d58601b0416d06374aaa722f3f7c7632006a5aa750fb9d53"
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

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end