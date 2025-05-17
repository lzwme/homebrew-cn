class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https:github.commattermostmattermost"
  url "https:github.commattermostmattermostarchiverefstagsv10.8.0.tar.gz"
  sha256 "f7fd48a3bc9ee41fcaf70e8e1ef0841d9a7e17533f71eacd67de64021c95915c"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https:github.commattermostmattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5b05b4b9f7c00b5adec2724e29c677d3377df12d7c86a518fe16a34a4f1fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5b05b4b9f7c00b5adec2724e29c677d3377df12d7c86a518fe16a34a4f1fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe5b05b4b9f7c00b5adec2724e29c677d3377df12d7c86a518fe16a34a4f1fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "060df52dedeed452531762969680834d008fb26e1e45186787fc0ee4fdd19cec"
    sha256 cellar: :any_skip_relocation, ventura:       "060df52dedeed452531762969680834d008fb26e1e45186787fc0ee4fdd19cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da0df6c77b06ae5cdfdde2f9182f9621e827f3ad6de789eef05d90d7e93741a"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("serverenterprise")

    ldflags = "-s -w -X github.commattermostmattermostserverv8cmdmmctlcommands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), ".cmdmmctl"

    # Install shell completions
    generate_completions_from_executable(bin"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}mmctl help 2>&1")
    refute_match(.*No such file or directory.*, output)
    refute_match(.*command not found.*, output)
    assert_match(.*mmctl \[command\].*, output)
  end
end