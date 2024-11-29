class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.44",
      revision: "ded6e867cd3ea82864619bc9aad036fffde94741"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18349a0a7abc47fa768f590756aef459650c0981bdace296d051babaddb87d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b18349a0a7abc47fa768f590756aef459650c0981bdace296d051babaddb87d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b18349a0a7abc47fa768f590756aef459650c0981bdace296d051babaddb87d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1e6c9badc9de98a831c85a0319e19c9b58b5a034f01219438d6dc149a1689c"
    sha256 cellar: :any_skip_relocation, ventura:       "4f1e6c9badc9de98a831c85a0319e19c9b58b5a034f01219438d6dc149a1689c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39b1c76d82dba78e46e456e192db05184c461e8eabb60538b876d69b07047e0"
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