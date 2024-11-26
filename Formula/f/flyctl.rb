class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.41",
      revision: "b983a0d0b98cf771c58d1ecb998097e641c2fb7b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a0fe24f1529a2b9e1749f3c41cdb712c99e244a085255a7c7ff36147e4bc40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0fe24f1529a2b9e1749f3c41cdb712c99e244a085255a7c7ff36147e4bc40f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a0fe24f1529a2b9e1749f3c41cdb712c99e244a085255a7c7ff36147e4bc40f"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c09c39ffb61781c190b305bf78a25b53cbd0df957aeb803edc80948beaf9de"
    sha256 cellar: :any_skip_relocation, ventura:       "48c09c39ffb61781c190b305bf78a25b53cbd0df957aeb803edc80948beaf9de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad810d3ea65d016763592e444c302a7391a178befb46fdbd4967d8cebdd9f104"
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