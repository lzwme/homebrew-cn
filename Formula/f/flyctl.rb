class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.118",
      revision: "e964b2acefccba21f3ebe5ee857d1b4c0d726861"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b5b12722e9e1e643c9923e558181d0d511f74cf08d7a700aa170d973068d55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b5b12722e9e1e643c9923e558181d0d511f74cf08d7a700aa170d973068d55a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b5b12722e9e1e643c9923e558181d0d511f74cf08d7a700aa170d973068d55a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fdc53e01c0bc037ef1ffb11d0bafc3b6e4fd6646c5e4d0aad3ac6f9cfcfe810"
    sha256 cellar: :any_skip_relocation, ventura:       "9fdc53e01c0bc037ef1ffb11d0bafc3b6e4fd6646c5e4d0aad3ac6f9cfcfe810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a712de98090367ec973539f347e642f77bcee8e4cea1247f14367e17bc87aa39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05115e9f3c57bc2cd6987a62791d25b114fcd92a779532518b82a76c936bf6e4"
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