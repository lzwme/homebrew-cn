class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.85",
      revision: "bf17047d74ae51513373d10e0bdf9f797c62a5d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1650655175983b64561cd46c7e6e8f85bf8aff917fb74f8e90191ae7ba9d293b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1650655175983b64561cd46c7e6e8f85bf8aff917fb74f8e90191ae7ba9d293b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1650655175983b64561cd46c7e6e8f85bf8aff917fb74f8e90191ae7ba9d293b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bb52db3e57733adeba6507597eb30c476a81200ed8f729b1afa65d77571b204"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb52db3e57733adeba6507597eb30c476a81200ed8f729b1afa65d77571b204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e84cf6cda4d72771d256f890f78e4557da276676d8c43c5951b9b192542d5f10"
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