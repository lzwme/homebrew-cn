class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.101",
      revision: "3debb29b735e52b5cfebc17b050b80622eb9a6a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "049655f01eda34a0752f5a8989cf9648bb72fb0a0875cd501b340d7c8016d295"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "049655f01eda34a0752f5a8989cf9648bb72fb0a0875cd501b340d7c8016d295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "049655f01eda34a0752f5a8989cf9648bb72fb0a0875cd501b340d7c8016d295"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dec0156ac4e67a345c008a695e3c238ba54f48cba2b090bce236c6a60b2fc86"
    sha256 cellar: :any_skip_relocation, ventura:        "4dec0156ac4e67a345c008a695e3c238ba54f48cba2b090bce236c6a60b2fc86"
    sha256 cellar: :any_skip_relocation, monterey:       "4dec0156ac4e67a345c008a695e3c238ba54f48cba2b090bce236c6a60b2fc86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d067e5f84ef587c7010aca4dfaabaf134b5b2fb39535373dfcbf5596ab639877"
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