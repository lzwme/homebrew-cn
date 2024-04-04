class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.27",
      revision: "afb532495fe083e0af624754c45d7f338ebb095c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "accec3cd11e221626960667dc624249a5f214d451df077e7bb4dfe1270c1d13f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "accec3cd11e221626960667dc624249a5f214d451df077e7bb4dfe1270c1d13f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "accec3cd11e221626960667dc624249a5f214d451df077e7bb4dfe1270c1d13f"
    sha256 cellar: :any_skip_relocation, sonoma:         "06c19715d33372c7aea2d1797065c47a6dd8dcfd389088c3548bf906600b4ba4"
    sha256 cellar: :any_skip_relocation, ventura:        "06c19715d33372c7aea2d1797065c47a6dd8dcfd389088c3548bf906600b4ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "06c19715d33372c7aea2d1797065c47a6dd8dcfd389088c3548bf906600b4ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a212dea811051424b396fa8349b62d2715c06b09e8d169126e6706c5bcc9e7"
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