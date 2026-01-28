class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.9.1",
      revision: "3153c92357a681cc40a17539e04a4500469c12bb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f4effa0c3011306278629474c04e4a79fb0020bac9df1cf72a45baa43415ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f4effa0c3011306278629474c04e4a79fb0020bac9df1cf72a45baa43415ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9f4effa0c3011306278629474c04e4a79fb0020bac9df1cf72a45baa43415ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e8a91dd3028638578b65254fea8ad344c94dcdc4557ce69514a45abb794d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5f7b70f596c391c54a07651bd1d709db056bd3c1fa5746862d1909703e9bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7706009cf66dd597661e10fbae084236fc65fd2b445f409715fd76e6061772"
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