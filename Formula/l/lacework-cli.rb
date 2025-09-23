class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.7.1",
      revision: "d8817b8f53a62a0fcdeb1a20396b9b16238c3f0f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ac0ee273a2c173062c95c7dfac9b5f141adedfd1113a20056560a42ad913cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ac0ee273a2c173062c95c7dfac9b5f141adedfd1113a20056560a42ad913cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1ac0ee273a2c173062c95c7dfac9b5f141adedfd1113a20056560a42ad913cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "195f1a105833f7c6a7e8c35517a682001468295b9cccacb070dfd592bfb7c0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf0ae8fe35d62b9439b5dac9a6a1c344772a7e11b95adfdeb2545ce43e792ad"
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