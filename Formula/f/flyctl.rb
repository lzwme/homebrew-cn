class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.8",
      revision: "db4d0d7641f87f0e9c1f46bd1728794e78f0f294"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74906a2c5ccd2af0467cca50df2f0657db5d2424ee24c0c275488c02b9f3d9dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74906a2c5ccd2af0467cca50df2f0657db5d2424ee24c0c275488c02b9f3d9dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74906a2c5ccd2af0467cca50df2f0657db5d2424ee24c0c275488c02b9f3d9dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "592ed84b3047b9a6dacf44a3ab3e3707606453d8a36642833b3c7fc596c2222d"
    sha256 cellar: :any_skip_relocation, ventura:       "592ed84b3047b9a6dacf44a3ab3e3707606453d8a36642833b3c7fc596c2222d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5adcc6ee6a45c4d8551c8325406afcf091e2eddfeb7cd8db7632754d4c8303c"
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