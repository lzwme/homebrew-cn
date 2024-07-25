class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.96",
      revision: "0487be13fd272e3cf7e0df984f167e652ea75c70"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b8c988c09570bb3819a85fbd275f9fc56611a2439c524a7f5769efcc97f159a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b8c988c09570bb3819a85fbd275f9fc56611a2439c524a7f5769efcc97f159a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b8c988c09570bb3819a85fbd275f9fc56611a2439c524a7f5769efcc97f159a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e0966ecee25deb52ff9629acc24eab007e1d3691c245407d69ed05553baef6e"
    sha256 cellar: :any_skip_relocation, ventura:        "7e0966ecee25deb52ff9629acc24eab007e1d3691c245407d69ed05553baef6e"
    sha256 cellar: :any_skip_relocation, monterey:       "7e0966ecee25deb52ff9629acc24eab007e1d3691c245407d69ed05553baef6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c630ce4fe083b7d6938f9659bccd8c6ab8baf945bc32ec6b37f353c07c15dacb"
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