class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.86",
      revision: "7690b28028e6b90648366011aba3943fd661b0b1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9242c02609e68f93d476f91270bc61e781b905d66bd4f3e3190c2020e8efda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9242c02609e68f93d476f91270bc61e781b905d66bd4f3e3190c2020e8efda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d9242c02609e68f93d476f91270bc61e781b905d66bd4f3e3190c2020e8efda"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2abf6ad579998b3aec976ae54a5ff4fe965a51b1239d2e72b134299d01beae3"
    sha256 cellar: :any_skip_relocation, ventura:       "d2abf6ad579998b3aec976ae54a5ff4fe965a51b1239d2e72b134299d01beae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f553c4948cfa28e9fe345027f5770572453be934fcf58a97511c713bdb31794"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

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