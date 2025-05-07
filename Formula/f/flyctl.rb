class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.116",
      revision: "b4df9606794f60631ae90b7beef39d39227c3ede"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2f2d6cf3510166a258926d3c2395e739d813abd3b36411b7fb1520ba41b5571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2f2d6cf3510166a258926d3c2395e739d813abd3b36411b7fb1520ba41b5571"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2f2d6cf3510166a258926d3c2395e739d813abd3b36411b7fb1520ba41b5571"
    sha256 cellar: :any_skip_relocation, sonoma:        "75858ea3be2bb291c58dfb76b98f190537fa0b096ceb3e298b8caddada2fea4f"
    sha256 cellar: :any_skip_relocation, ventura:       "75858ea3be2bb291c58dfb76b98f190537fa0b096ceb3e298b8caddada2fea4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c76479608b375abec0d1ec8e88e0aa148c54910f822039bc5fab11ba2bf0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d79a0ec28a92c948975bfb3e07e0dc0944da59dd4a5ca09eda4b1f248f57e70"
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