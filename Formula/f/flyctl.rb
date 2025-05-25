class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.130",
      revision: "2140c4f86adc8c200ba68727588f5af3d7d62dc9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d380af7b282d542d67a4329c5abbc6b74dafd40cb8e278e17f6fa8bfdb0cf542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d380af7b282d542d67a4329c5abbc6b74dafd40cb8e278e17f6fa8bfdb0cf542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d380af7b282d542d67a4329c5abbc6b74dafd40cb8e278e17f6fa8bfdb0cf542"
    sha256 cellar: :any_skip_relocation, sonoma:        "796742864fe211b320c040133216c0010e08ca59657e954fdf63475a4de36c0e"
    sha256 cellar: :any_skip_relocation, ventura:       "796742864fe211b320c040133216c0010e08ca59657e954fdf63475a4de36c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ee2e26f361af1d329958d56dcc058eedef09176e44e0e3b9b662e3f527984c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5295bebe4104c8c470af1cd7a8552cee17da1e7b099ff5a2281d305ae60f88"
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