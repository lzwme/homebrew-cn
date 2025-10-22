class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.2",
      revision: "f438f7bd70961b40d045b4720671f4c61e55aa03"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58a743ff0f4ac1ba3a5acbb7a9c8848c9f96c3a1f84f1a7ea0c1db7122eb2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58a743ff0f4ac1ba3a5acbb7a9c8848c9f96c3a1f84f1a7ea0c1db7122eb2a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58a743ff0f4ac1ba3a5acbb7a9c8848c9f96c3a1f84f1a7ea0c1db7122eb2a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a603ea7bf05f35945e51489247179ef40fa398928f0049a07dc33cdd5e06a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d02b151e5384779e80db689e4b73ed537de8b6265bd9ea708f60fca654b7b451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03bdd2f135da4362b54eaf753bdbe4aa40a176771ba6428f35e596387e020ec3"
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