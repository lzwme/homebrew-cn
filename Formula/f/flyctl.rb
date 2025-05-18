class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.125",
      revision: "c78d4555c62f257c686bd6c0280f1fb1c59a4e4f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "781d1bae93e00f3ae995a2e103ca029cda0a1d2c3ce10053510009fca8460f59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781d1bae93e00f3ae995a2e103ca029cda0a1d2c3ce10053510009fca8460f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "781d1bae93e00f3ae995a2e103ca029cda0a1d2c3ce10053510009fca8460f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f347b09d857e99250f496e12edbb2c4a617a730801d89b686db8e060d9cfcb9"
    sha256 cellar: :any_skip_relocation, ventura:       "4f347b09d857e99250f496e12edbb2c4a617a730801d89b686db8e060d9cfcb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc3dce7608686ead7543da4f2730d5c54241cd47066c021db52aa1247d618553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e81fc4424af5b0dbfa75e805dceacf0f459cb6a23010a8d8ac0bc6f4478932"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

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