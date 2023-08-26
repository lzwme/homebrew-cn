class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.30.1",
      revision: "8b703667fa6bc9781d66b21566de960fe2ddd167"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cf1867452ff374e41dc3c4d0265c42d64f592abea5b580896194555cc5e24a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe54d946688f1839c7fb43606b04d9ebc5cd6419deacc5f274c0fdb58bf07bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc64d9b83f73f5df3f920cd61a2f9c9853e6c6a0991a8818b3ff40d86f298cf5"
    sha256 cellar: :any_skip_relocation, ventura:        "1d0e6c99a1ef511436ef15c0cd57baa29f4ef873319d74e731930f004b2f4ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "fde9f6a5b64d7b6f393ace9b9ade839acbfdb2aa7e694f6848bb6cdd5d0f1997"
    sha256 cellar: :any_skip_relocation, big_sur:        "f482fdaf058dc2e1c0865b5dd6623fed68f3ecff6a5b280093e4c42a5c92ad31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7237b003fed58449e73e4e3278e3084b747f494b6e879fa35b1153ffc06521"
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