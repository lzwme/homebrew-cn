class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.122",
      revision: "a239452a84c167cac5d500afecbae9d3b3aa2d7b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce38d28c57c450f86920140e696e2dab59a133b6f9d7dfd9ebe2fd5a53e3a74b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce38d28c57c450f86920140e696e2dab59a133b6f9d7dfd9ebe2fd5a53e3a74b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce38d28c57c450f86920140e696e2dab59a133b6f9d7dfd9ebe2fd5a53e3a74b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b9da6d5e865e4f1d6ee9fccf3f5d3bf42d2a6388be85958d90e8e168e673ca5"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9da6d5e865e4f1d6ee9fccf3f5d3bf42d2a6388be85958d90e8e168e673ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9da6d5e865e4f1d6ee9fccf3f5d3bf42d2a6388be85958d90e8e168e673ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c5d5ec255612db34f4e788aecf872e33d20c7a83fe8ffc157a8c7349e65c92"
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
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end