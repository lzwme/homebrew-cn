class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.55",
      revision: "0a7df8d78123d5809167cdaa11a78dec92a87e47"
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
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de893ac4a5090fd622215849d8fb4e9d0e45d256f5e40c0eca33f426976f98d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4de893ac4a5090fd622215849d8fb4e9d0e45d256f5e40c0eca33f426976f98d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4de893ac4a5090fd622215849d8fb4e9d0e45d256f5e40c0eca33f426976f98d"
    sha256 cellar: :any_skip_relocation, sonoma:         "412ad460c966bc066e9019f5b05e671a5e623705a868a60505f3b18b95934dab"
    sha256 cellar: :any_skip_relocation, ventura:        "412ad460c966bc066e9019f5b05e671a5e623705a868a60505f3b18b95934dab"
    sha256 cellar: :any_skip_relocation, monterey:       "412ad460c966bc066e9019f5b05e671a5e623705a868a60505f3b18b95934dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ae09c45f9d8527cd2bb9044253373862e4eb052f9c7c07b1346e66269d654f"
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