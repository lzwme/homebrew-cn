class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.112",
      revision: "63cbb128535cdbf80ba2d5d82eac29bdc21ec56f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55e32fba12331711cce9875d4f7329d48e46dab5d716524a9056323b023457f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55e32fba12331711cce9875d4f7329d48e46dab5d716524a9056323b023457f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e32fba12331711cce9875d4f7329d48e46dab5d716524a9056323b023457f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f3934f12c3bcad3d8170fcbab432022cabd58e91118d577a47e33a2e575b22"
    sha256 cellar: :any_skip_relocation, ventura:       "37f3934f12c3bcad3d8170fcbab432022cabd58e91118d577a47e33a2e575b22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e8e5dcfd8ff2f11d3f171a32b52e5c5671842347b63c56137ad9d7ce7e1069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccef2cb2cc46e415dd2ba4915a99f1a296400d715341ffaadedb71e17f6d6656"
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