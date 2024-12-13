class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.50",
      revision: "a9c2fb39a36edbff834da9d35704dd351203461b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c16f495fb489793246b1e94aa25c10412fcc68934f1e06f9c2559b60a121ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c16f495fb489793246b1e94aa25c10412fcc68934f1e06f9c2559b60a121ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3c16f495fb489793246b1e94aa25c10412fcc68934f1e06f9c2559b60a121ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f277881a194b43230507bf05aa348177481db49c83a2399816396c2921b4a2"
    sha256 cellar: :any_skip_relocation, ventura:       "93f277881a194b43230507bf05aa348177481db49c83a2399816396c2921b4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfef46fc999460f3b2ceebce60a0077194086fdff5c4dd9bdc2387a1241b056"
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