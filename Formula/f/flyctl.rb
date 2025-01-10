class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.61",
      revision: "a867d6bd190c533de7cc3f0e58c7af1907ea1584"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20de4a788accaf92a5bf784a96dd9732b241fb58c35fdc949191ab67bb6b2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20de4a788accaf92a5bf784a96dd9732b241fb58c35fdc949191ab67bb6b2cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b20de4a788accaf92a5bf784a96dd9732b241fb58c35fdc949191ab67bb6b2cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "891ebf48e2b59de527839ee7483406b09a69efa23579eb9b8be14b9447f9359e"
    sha256 cellar: :any_skip_relocation, ventura:       "891ebf48e2b59de527839ee7483406b09a69efa23579eb9b8be14b9447f9359e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08bb42c327fb91260735c2213271457166cf15a5542734ba5cea5d001614d9cb"
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