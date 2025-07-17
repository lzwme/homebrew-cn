class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v10.10.1.tar.gz"
  sha256 "c263030be8e4bb242948230e4e700e69a0ed31b7fa83f91e6fdb3bdfb25a8bee"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34cc6a21b98ce1337f6023af2eab053e252c47c73c9dfdf3cdda56cadb427e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34cc6a21b98ce1337f6023af2eab053e252c47c73c9dfdf3cdda56cadb427e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34cc6a21b98ce1337f6023af2eab053e252c47c73c9dfdf3cdda56cadb427e1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdc19a808c8ea8f23a07b822ee89f1e39689491625a8a07a935a3ceb445cf44e"
    sha256 cellar: :any_skip_relocation, ventura:       "cdc19a808c8ea8f23a07b822ee89f1e39689491625a8a07a935a3ceb445cf44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4190614d5a917d209b48f50224914f4a250b5aca03049fafaafb196c4ad3f7f9"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")

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