class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.10.4",
      revision: "e5743a6789cbaa280af91d1064924a159a80f82d"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd41d3631d946b9e19b35016772c6adfc5e6ca88a6dc5c657932d665dc98164e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd41d3631d946b9e19b35016772c6adfc5e6ca88a6dc5c657932d665dc98164e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd41d3631d946b9e19b35016772c6adfc5e6ca88a6dc5c657932d665dc98164e"
    sha256 cellar: :any_skip_relocation, ventura:        "82997696be9f402ec8660dd12fa8426b4c6113f5cf6040ddb575df1e51958b66"
    sha256 cellar: :any_skip_relocation, monterey:       "82997696be9f402ec8660dd12fa8426b4c6113f5cf6040ddb575df1e51958b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "82997696be9f402ec8660dd12fa8426b4c6113f5cf6040ddb575df1e51958b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b6481cd8b1907a7aec611e6b0a28b23c09bd71e582112d1c6bd4d915549c9af"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

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