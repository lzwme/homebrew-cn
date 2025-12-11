class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.4",
      revision: "edf92c488cac5431929aa5d5474347d17842ff52"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7e9303020662c4a2f30af60b0fcf51914641654b1e0e79732df904fbe488e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7e9303020662c4a2f30af60b0fcf51914641654b1e0e79732df904fbe488e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e9303020662c4a2f30af60b0fcf51914641654b1e0e79732df904fbe488e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa0a91a4dee47e21d65d8f4fcc896db08c564cbf8931c4be592d8b9ed4da63d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78af7e46ee788e5b2d99654b2d55bfbdec64e9148eb0c8e0ec2b4cad8a67ac4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4d339cda920aedfdd70bb3279dc5007499607a1c247051470c23164cd3b098"
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