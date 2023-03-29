class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.15.1",
      revision: "59f52b06639fbfb16aa00e3d807e8a890aa4db0d"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eedae27a4094b4a8a27593995b10f39c20dd2893fff46299d5695f8fb8865f2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b1b5ba7ecb7f0ac5354d3fd67e1268be020b72b8fcea3e0b1ffa8a9eaf3930"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76bb91df092567f52d00ebc1ce7b7ef939eefb2105425056e4466e3805d5a846"
    sha256 cellar: :any_skip_relocation, ventura:        "3dbe0953e5a14f3266946c85b7935c8bde14a72b3943ab9e22493d8a6b003e3b"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8599b399762282df9650629f09b653d1f473ea34d74b6fbc35cdb66b6ea703"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bfb1772343f0033a353367fe74a2c405884c84dda12a042e3ffdabbd3549247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8772687af8e02a8972d9de8f050e3eab062817ba21415ad7551323197a40f095"
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