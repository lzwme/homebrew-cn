class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.18.1",
      revision: "32dbfc0f8e03fab20471038555c61a150fbabcb9"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f19429d352fa44c26b6aad42b8f23e6bc94ac69c0fa099dc5023ce368b88f927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e4fd7ab5c51e7a07b9e97b803222dd5e3ee96710fe673419509e4fb0af02e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78fb2d9cc4b33bbac18588380d94b8f36ea73ae845811ecb0fa7bd7f7a5a165a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f999273a2800049c61b1beea2a5c937ff65d87c716467f7c25ca9a11c46f410"
    sha256 cellar: :any_skip_relocation, monterey:       "a60588e5cdb716864fa3efaf522c616aca96db594d3ffadfd654d8480b0f84c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae9d3e081d7de70fa3febcbad80827d5f027465cb43da584a6f771401170653c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "917cbde85d75ad24d3f5b9bda12aec68475fe362e0b761b755395ca6557b3861"
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