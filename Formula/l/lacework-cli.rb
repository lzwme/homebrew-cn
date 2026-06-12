class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.14.0",
      revision: "cdcf9c86b83836f23f5ca0b915c5d6373eafd524"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b6451801a5fa9dbc701f857fd130e0cdedca256c6c88bb1c1eb78c3406f1242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b6451801a5fa9dbc701f857fd130e0cdedca256c6c88bb1c1eb78c3406f1242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b6451801a5fa9dbc701f857fd130e0cdedca256c6c88bb1c1eb78c3406f1242"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25b05b0ef6aa975d45625bf4d4a66bdbacc455a3c725bea153bad4c9ca8b593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ab0182ca91fabe683d70ddf7015847112e4fd4d5deb70717f22cc7405d27e9"
    sha256 cellar: :any,                 x86_64_linux:  "f0366b4db8a9a9a1ba487004f82f939a7fb54ad8ba41f07c09686e610e806f1f"
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