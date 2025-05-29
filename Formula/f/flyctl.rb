class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.134",
      revision: "c6b3211ba14eae60087ba5f89061df20ffa8faa7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6433b890a5b1baaf19d1c2897c3698d133c7fceaf731714a50080e11d2215268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6433b890a5b1baaf19d1c2897c3698d133c7fceaf731714a50080e11d2215268"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6433b890a5b1baaf19d1c2897c3698d133c7fceaf731714a50080e11d2215268"
    sha256 cellar: :any_skip_relocation, sonoma:        "6262f6ccc798874a298e42f822889f1af7336ddb84cf858d079286c0ac700f6d"
    sha256 cellar: :any_skip_relocation, ventura:       "6262f6ccc798874a298e42f822889f1af7336ddb84cf858d079286c0ac700f6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fda036b86b6ac55850c0ac3e0f28d579c4b58773070193c27f629d626f20edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf5fd37b506dfb9a1d3b7427b18101f2eaec77a725d5274da612c1920fb39bd"
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