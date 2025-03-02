class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.87",
      revision: "17ba68cea285eeaea67bc3e8c2ccc7621fede98a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78fd7e58c635e9f77258a489be0fc4ffd8fc85d97d503ec0f0030dbb70ff3be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78fd7e58c635e9f77258a489be0fc4ffd8fc85d97d503ec0f0030dbb70ff3be6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78fd7e58c635e9f77258a489be0fc4ffd8fc85d97d503ec0f0030dbb70ff3be6"
    sha256 cellar: :any_skip_relocation, sonoma:        "09206ef89bd7c85fd247a8dfbf6688e64b44f25df1bb326f115a782435490387"
    sha256 cellar: :any_skip_relocation, ventura:       "09206ef89bd7c85fd247a8dfbf6688e64b44f25df1bb326f115a782435490387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62575e9eedea8790c5a9c44761cb1e8156cca89e2e45b0b0cd967169ba1666d7"
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