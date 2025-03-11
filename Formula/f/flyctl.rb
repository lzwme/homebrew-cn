class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.88",
      revision: "95313784d48e6e385fda5095a1f6a051200b7163"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e7adeb351be6daaae9b54dd45bb808d655f0d354e049279d8e2f0448a2e4e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e7adeb351be6daaae9b54dd45bb808d655f0d354e049279d8e2f0448a2e4e52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e7adeb351be6daaae9b54dd45bb808d655f0d354e049279d8e2f0448a2e4e52"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e2e0e6cb3fde1d3eed1da39caa28edb48c28bf32bf81de5495627670b62a0f2"
    sha256 cellar: :any_skip_relocation, ventura:       "5e2e0e6cb3fde1d3eed1da39caa28edb48c28bf32bf81de5495627670b62a0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc0ee215444e164cc9291079fbe3024d2df56dab5ba2153b7a9fad87fc49d82e"
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
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end