class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https:github.commattermostmattermost"
  url "https:github.commattermostmattermostarchiverefstagsv10.6.2.tar.gz"
  sha256 "2c1be668b9d8d47f308dbaf841d95af1600c693d0bdf16a0c27d494024d460d5"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https:github.commattermostmattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21c5884a6804e7bc69824adb52c42c632341bd8c96d2083856d7d3324dfb7d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21c5884a6804e7bc69824adb52c42c632341bd8c96d2083856d7d3324dfb7d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21c5884a6804e7bc69824adb52c42c632341bd8c96d2083856d7d3324dfb7d3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "48bf857241616ca7992c0e9cb7931e27fbb6a439d9769056f86cd8e7b30363c8"
    sha256 cellar: :any_skip_relocation, ventura:       "48bf857241616ca7992c0e9cb7931e27fbb6a439d9769056f86cd8e7b30363c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3605e339ce9f9abb6a961b05048fef423bdb8f774aa78fa51125dc48fee0107"
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