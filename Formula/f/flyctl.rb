class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.73",
      revision: "9634890c3e70f46d1108a34fecd037c3da319d9c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b08e2be045b068d139991f37a5ebf15d7d8e67ab9e0a35590196ba406fa84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b08e2be045b068d139991f37a5ebf15d7d8e67ab9e0a35590196ba406fa84e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92b08e2be045b068d139991f37a5ebf15d7d8e67ab9e0a35590196ba406fa84e"
    sha256 cellar: :any_skip_relocation, sonoma:        "06963162c25057253d2044528da1d4ed35769ea908bc6eb36484b825d59b69c1"
    sha256 cellar: :any_skip_relocation, ventura:       "06963162c25057253d2044528da1d4ed35769ea908bc6eb36484b825d59b69c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aded30b42a0ad482e3a445bf6f0068339937fcc434f988ba9314f4e3600556ef"
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