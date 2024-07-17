class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.90",
      revision: "062495be4970e16f2248118aff85e3c79fe008fa"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e4e7e734e9f051d4e8aee1f4ea81ccab9daa9a0efa3aec9bb49bd0fb9d6fd2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e4e7e734e9f051d4e8aee1f4ea81ccab9daa9a0efa3aec9bb49bd0fb9d6fd2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e4e7e734e9f051d4e8aee1f4ea81ccab9daa9a0efa3aec9bb49bd0fb9d6fd2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c917a6f698d2cf8a324b9e2dca9ee7ca390c6373578d73082e6807a19e8fab9"
    sha256 cellar: :any_skip_relocation, ventura:        "4c917a6f698d2cf8a324b9e2dca9ee7ca390c6373578d73082e6807a19e8fab9"
    sha256 cellar: :any_skip_relocation, monterey:       "4c917a6f698d2cf8a324b9e2dca9ee7ca390c6373578d73082e6807a19e8fab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17824ba7a596424176345b27d174e392793f12bca8b8729bd9506b67f34a009d"
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