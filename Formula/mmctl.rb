class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.9.2",
      revision: "3f9c6210e7050c273906ffbf7c7bb1bf6a720738"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9b51139c2478337100c723dcb13d7a4a9100db447f20cdeaaa856ad1784340a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9b51139c2478337100c723dcb13d7a4a9100db447f20cdeaaa856ad1784340a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9b51139c2478337100c723dcb13d7a4a9100db447f20cdeaaa856ad1784340a"
    sha256 cellar: :any_skip_relocation, ventura:        "a25c9eba00efce25c8b5d46b0332546921b29d3be18b92b23198cf67ca36cf08"
    sha256 cellar: :any_skip_relocation, monterey:       "a25c9eba00efce25c8b5d46b0332546921b29d3be18b92b23198cf67ca36cf08"
    sha256 cellar: :any_skip_relocation, big_sur:        "a25c9eba00efce25c8b5d46b0332546921b29d3be18b92b23198cf67ca36cf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aad26ad6fe524bdc03992f55358207c5a4b3ab6a498e5fe64df040db581bb2d"
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