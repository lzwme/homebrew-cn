class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.110",
      revision: "1497bac6e3097fd6e0ba9472a50d04b39d079f34"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "472c3fe2a4912d2f558c0cb84426d3e65b852b9602b6ea2258ef8785d3372a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472c3fe2a4912d2f558c0cb84426d3e65b852b9602b6ea2258ef8785d3372a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472c3fe2a4912d2f558c0cb84426d3e65b852b9602b6ea2258ef8785d3372a2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7336ececeaabd706e99ad37ce3ac657c162d6ebb5f6f7df1d9c9c49ae2a05347"
    sha256 cellar: :any_skip_relocation, ventura:        "7336ececeaabd706e99ad37ce3ac657c162d6ebb5f6f7df1d9c9c49ae2a05347"
    sha256 cellar: :any_skip_relocation, monterey:       "7336ececeaabd706e99ad37ce3ac657c162d6ebb5f6f7df1d9c9c49ae2a05347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ba30edb1cceb8cf06be647e85aca67e049e0200ae0a231f662e27ad159fed90"
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