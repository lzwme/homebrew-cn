class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.8.1.tar.gz"
  sha256 "87c83443c047ac0459ce2fe28c19b6b45c542169c10ee08e72e0bf21b6340bcc"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37a1e7f41146f5aad9edbb7b6ed149783da59acaeea5ce90f2cc2994fde91545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37a1e7f41146f5aad9edbb7b6ed149783da59acaeea5ce90f2cc2994fde91545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a1e7f41146f5aad9edbb7b6ed149783da59acaeea5ce90f2cc2994fde91545"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad4d1ca447665c1a24c64204396129ca2dcb22d916559efc51f5189117c444b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a846346b2a5db1e09b9675c928988188d984be9596c58b21d10d55e953c529"
    sha256 cellar: :any,                 x86_64_linux:  "05ecd403cffa8bb1d72c8555bea862eadeea2e3b5ab122b18f5d027b10c55edb"
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