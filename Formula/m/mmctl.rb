class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.7.0.tar.gz"
  sha256 "4b006ac8307139f94fd1ce28a046fbdf1b7c16bebacae6343a1272b0d0cfaecc"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfae1fc99b93e7392cec45c244b05768f82cc814e4bcf9152e4b0104a89a96da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfae1fc99b93e7392cec45c244b05768f82cc814e4bcf9152e4b0104a89a96da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfae1fc99b93e7392cec45c244b05768f82cc814e4bcf9152e4b0104a89a96da"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf8a55cd6a870d7af16f559e78adcf223d636e8a50484360ab68e96c2bb86fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f3a0a084f15e5412d51fe4daba9a44e6f68068fb56f8709076b6afd88b9758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d128f76d26fb0c3a081e34bf10c6477e2e52aa7076a156e48f359299f8152ba9"
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