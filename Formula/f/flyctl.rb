class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.52",
      revision: "339cefc55b19cf94077b5a1437c42a3b2d4c5ac0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23d77e95429695bf27196260ff666ddcd8b81704fc50d53c518e268447e31fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23d77e95429695bf27196260ff666ddcd8b81704fc50d53c518e268447e31fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f23d77e95429695bf27196260ff666ddcd8b81704fc50d53c518e268447e31fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0588cbc603e5bd47ea64a33225f05a51e928ed90de93f35ae018969f01f55fcf"
    sha256 cellar: :any_skip_relocation, ventura:       "0588cbc603e5bd47ea64a33225f05a51e928ed90de93f35ae018969f01f55fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516b48aaa072524fefbb27cce88e8240681a1ad1ae242a8d8907529ed69ac4ca"
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
    generate_completions_from_executable(bin"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end