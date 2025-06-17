class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https:github.commattermostmattermost"
  url "https:github.commattermostmattermostarchiverefstagsv10.9.0.tar.gz"
  sha256 "06dac02af4c0ad15574c6c7f58a40b798aa1d9bb22c7ca8ba60f73b8fcdb5e12"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https:github.commattermostmattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cffe13ba45b171ece3947760af59e1a78dea7f4cd4fc6fd70a87ecf4a3ad6e0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffe13ba45b171ece3947760af59e1a78dea7f4cd4fc6fd70a87ecf4a3ad6e0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cffe13ba45b171ece3947760af59e1a78dea7f4cd4fc6fd70a87ecf4a3ad6e0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b29a8711a2a10cb0e787990dac7f49167d044d9c51c8095c6e593d48d0c0fc"
    sha256 cellar: :any_skip_relocation, ventura:       "22b29a8711a2a10cb0e787990dac7f49167d044d9c51c8095c6e593d48d0c0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfb3ac6d42d91f2e8d3eea047ee3f7a70fde38685ee5cd136a0fd3f7f7b1bb0d"
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