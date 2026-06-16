class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.7.3.tar.gz"
  sha256 "cda95c17a2fa046b28af6a6645d39731922bc70f557511f63874126abc54e342"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c0e6e0f0254e7bf78da88e91a91b1f182f8d15e93cfbec361bf4ca7830f5e00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0e6e0f0254e7bf78da88e91a91b1f182f8d15e93cfbec361bf4ca7830f5e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0e6e0f0254e7bf78da88e91a91b1f182f8d15e93cfbec361bf4ca7830f5e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "9449dab9b19739fba1e88614cacd0a7ccb5717070d4baccc189ffcb6e43e0191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b850f64cae83e0861ac228ef21d3deb622c374653779ed46c9aead8b93848b66"
    sha256 cellar: :any,                 x86_64_linux:  "e3d6527069e9370fdc5f33635ac2e7be744ccb576e2b87d038ca42cbd5adb718"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end