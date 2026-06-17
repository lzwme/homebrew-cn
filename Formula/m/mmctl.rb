class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://ghfast.top/https://github.com/mattermost/mattermost/archive/refs/tags/v11.8.0.tar.gz"
  sha256 "6956c843ee90cb4e26613b30dda191376abd4beb85f89df3f57ec0a1c2cdaf7a"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee711712f7d185cbed795525f268974e60f412c492d364d2fb7912d4cdfd782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee711712f7d185cbed795525f268974e60f412c492d364d2fb7912d4cdfd782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee711712f7d185cbed795525f268974e60f412c492d364d2fb7912d4cdfd782"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ac6303cb7e6bdb09f8e5f77b18ba46c7ec54573520804a2b7ea9012c871630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23193ac53a6a089cdfff038d8441ef98a1b1f7c02b9b58343ff3754cd81b3066"
    sha256 cellar: :any,                 x86_64_linux:  "875ea8e1e0d27ec221f174babc6fb48d61f9a1edc2f109dc97d551a35d9fb958"
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