class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.138",
      revision: "5e0aac9a837d73a3a01ff01eb9ce1f78982ba590"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ead44a011ac36e83f783d89580e95e9ed2d0254e536be1456db283edb090466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ead44a011ac36e83f783d89580e95e9ed2d0254e536be1456db283edb090466"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ead44a011ac36e83f783d89580e95e9ed2d0254e536be1456db283edb090466"
    sha256 cellar: :any_skip_relocation, sonoma:        "3988c685ed67168b59c17571015b118fa253947b66d459557298f04ab57896ed"
    sha256 cellar: :any_skip_relocation, ventura:       "3988c685ed67168b59c17571015b118fa253947b66d459557298f04ab57896ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2421154cf0753559bb04496bc9511cb224ac706597451b2c5c8343b1a642cf0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b3a3d827a0844c68b5d028b66396641ee93445d38ac05cb9ca7d3ad35e59bd"
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