class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.140",
      revision: "4ffd0f78f2fdf38aabe4f8989e55905fe6802196"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8beab4351ba5f0de91d5429c8b25667ff358d21a702faa982bbc614fff552ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8beab4351ba5f0de91d5429c8b25667ff358d21a702faa982bbc614fff552ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8beab4351ba5f0de91d5429c8b25667ff358d21a702faa982bbc614fff552ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69a0f98397e69b407e0cd078d0b42ed35f94b2d1ab4717aad566845e20d11cd"
    sha256 cellar: :any_skip_relocation, ventura:       "d69a0f98397e69b407e0cd078d0b42ed35f94b2d1ab4717aad566845e20d11cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba25adfc89e6c5c7f48b9281a8b426e45db822139f13cff9e952c85a44aba90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037f6c012931e54ceaf2fc726c6393de9acd3afec31251e967348bfea58a0322"
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