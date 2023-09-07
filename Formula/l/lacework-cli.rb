class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.31.0",
      revision: "9d7723503d28416a2e624d2fd2b816e9a14dfab8"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ec92716d4198e0472fbf59f8f86476212e12326c5417bfad3f9415b59107a5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93a7ccdbe0cf1f47e037f8ff11e3f4f4ebff0899d8c11b08a7f2fa0f98e94b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42ee61a8fb0b9edf46f1f14b8215f75a10258b040379f4208c0acc652e8c78ab"
    sha256 cellar: :any_skip_relocation, ventura:        "76c0927688ffd2815eefbe63e22341bab3d60ff449d5688c72f51d2d277b8ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "d4feed2a31d054abf8202e897906d9f56806fc46ccc2c833c3f1155fd03be5c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d0f2725e0426589be58c68e7aa0f898910211f82eb1d2ea33d7a9294421863e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9594f6538a817e919c69084153db86c2308e6d713d0feda268111a3439799dc2"
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