class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.31",
      revision: "ce7819105b21dc8cb80333d5160bef9173aa7d3a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed14ac9a72394fcf6f783ccfc90f3a9e2cda7faffffee8aae67920c34f3ae3fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed14ac9a72394fcf6f783ccfc90f3a9e2cda7faffffee8aae67920c34f3ae3fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed14ac9a72394fcf6f783ccfc90f3a9e2cda7faffffee8aae67920c34f3ae3fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "221f64d5d4fdaf076d6f3f09e5032f12a21583f2215b54eb32a99dc57127f3f7"
    sha256 cellar: :any_skip_relocation, ventura:        "221f64d5d4fdaf076d6f3f09e5032f12a21583f2215b54eb32a99dc57127f3f7"
    sha256 cellar: :any_skip_relocation, monterey:       "221f64d5d4fdaf076d6f3f09e5032f12a21583f2215b54eb32a99dc57127f3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e118be0dac158f32eed344ac9eb077f1c2fa81b49424f9535a0f77202f2af56f"
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