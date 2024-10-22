class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.25",
      revision: "8fb314c9230ba972453b5ebf292214d10f076468"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f25f7128076ad0e3a6d9ae44d56d6fc123ed6b2e2609929f74294d14482da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f25f7128076ad0e3a6d9ae44d56d6fc123ed6b2e2609929f74294d14482da6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30f25f7128076ad0e3a6d9ae44d56d6fc123ed6b2e2609929f74294d14482da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bf11efabb4a6c68fae30c24224498f9630465c6cc42ca76ef0556be8efd4d9a"
    sha256 cellar: :any_skip_relocation, ventura:       "7bf11efabb4a6c68fae30c24224498f9630465c6cc42ca76ef0556be8efd4d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639a17929df6267e3a0750c86bf5c8abf47dc71e19dbf2aa5535f3cafa7adf50"
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