class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.44",
      revision: "543668219803a95958985a1025b8234443bad99d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdb357ba5e3bb04f5a49f575bfff8e3b04884f5d27234bc18abee0dd863cdf4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdb357ba5e3bb04f5a49f575bfff8e3b04884f5d27234bc18abee0dd863cdf4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdb357ba5e3bb04f5a49f575bfff8e3b04884f5d27234bc18abee0dd863cdf4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "862b55add6908cd87fb3f7d4e128f0c6e3e066744310bd766ae170f243f8e6fe"
    sha256 cellar: :any_skip_relocation, ventura:        "862b55add6908cd87fb3f7d4e128f0c6e3e066744310bd766ae170f243f8e6fe"
    sha256 cellar: :any_skip_relocation, monterey:       "862b55add6908cd87fb3f7d4e128f0c6e3e066744310bd766ae170f243f8e6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d716c30284d3cc9930f833de72b5e381992fd949f13bc5b6856fd8c8bcc4de3f"
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