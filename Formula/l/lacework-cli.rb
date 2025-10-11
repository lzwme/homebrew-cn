class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.1",
      revision: "ef54b4ad33d3bd73f9892d48439bb52c499ec1dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8df3d1e727843a98b5da38d7ba910b4f28660b5e89113aa88ede6d11a6423c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8df3d1e727843a98b5da38d7ba910b4f28660b5e89113aa88ede6d11a6423c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8df3d1e727843a98b5da38d7ba910b4f28660b5e89113aa88ede6d11a6423c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa1457ac40cb70b5d70ce855cb021eaeaed1b943dce353208f9088cfb7ce924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ac4de974508b9c4d4abc1a1287cef8c6e217bcd973b0b717f523df9a4bbe63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5688965c0930967685d411d2c647cb3ac68149b2cb7c19a3e19f70be530bb9c9"
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