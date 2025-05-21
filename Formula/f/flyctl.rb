class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.128",
      revision: "604d281778bb9a7aebfe47412e44e1c376a8fe35"
  license "Apache-2.0"
  head "https:github.comsuperflyflyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa08939cb094abe8381969d8d667ebe49dbe3e91ba2845e47567d6719bafb74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa08939cb094abe8381969d8d667ebe49dbe3e91ba2845e47567d6719bafb74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8aa08939cb094abe8381969d8d667ebe49dbe3e91ba2845e47567d6719bafb74"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb25fe6e4499fb7307df5d0326293b15909a78cecb200887626f2d86690f719"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb25fe6e4499fb7307df5d0326293b15909a78cecb200887626f2d86690f719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52bd47f826f7bdd5faf1dfcd59a9ab8cd3f785c23e930f9025cfedb98093f464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec71c222a2a2076d0ec03a17cfb567156bb292fdd1224050697031c57b91035"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comsuperflyflyctlinternalbuildinfo.buildDate=#{time.iso8601}
      -X github.comsuperflyflyctlinternalbuildinfo.buildVersion=#{version}
      -X github.comsuperflyflyctlinternalbuildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end