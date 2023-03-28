class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.15.0",
      revision: "5a60fa0860f965ba0cfc6768ad1df38c96ade23d"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0672342c186ec82acbd02f3a99687e03bfdbefbaf926b27fdbe96e3f6eb73eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33f3f9e4278d9c254c7207956f98b6ba620f9d28902237387fd48ecd659550e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70c4acf93216cdd7cf7bb20ed2b3a42b0672033a452e6572ccadd2606cc62913"
    sha256 cellar: :any_skip_relocation, ventura:        "0b44a7e96e897215ccaec4d589967c7fe560c34d7c3c99fa003a5789462f70fc"
    sha256 cellar: :any_skip_relocation, monterey:       "7f92cc15628faae8ae27145d5ee7ea53abc928e2b1951a1e60503fa90d432c5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c5c817eea70d85c7aa67c2614a5ec1bbf452909d3089b18053909c15a78cbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e6a98877028eee6a3b8bdab30fa51e7c0a4a65d4aa39e8a54e07c3f6711532"
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