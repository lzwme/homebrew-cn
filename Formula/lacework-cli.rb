class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.24.0",
      revision: "40797489c75bdfd68f1465d1e7219d3a28477412"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe028e34c308fa99dcad62398a533f110771b7d624bb0cb7aa6e75c8dc970e44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062912ece76fc5739c79e3ca8bc9d8954252bd1e58bc2c23f9d623f0fde315f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9ee65a332ccacb37d89335d0a5d2f241c4d1d3b9d80cd3680d8c3532eb4626c"
    sha256 cellar: :any_skip_relocation, ventura:        "72b9098b9b4f680fa272b56f57e7c4ee30f125c048eca6d8fd995d8d691e082e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f6b2b216fe594c143411ef28bcd69fd5ac593ffc3b37a10ee79d78c80066b98"
    sha256 cellar: :any_skip_relocation, big_sur:        "78a205e290b3c26994c17e876be63cef0932ce4fe58f3256e8a7b9e8b745e240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4f25aa940d7f951b92c32a0e8e25746b279139cf5ef6c5c39e25d6d64f270b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end