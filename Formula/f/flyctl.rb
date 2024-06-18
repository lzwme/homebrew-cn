class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.71",
      revision: "e1491edef1d9b04d94d54bfc893fef59c4d5bed5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af89f5457561abccf4d0ccc45f8d54e141766c4c2e64e3ad204d499163e3451b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af89f5457561abccf4d0ccc45f8d54e141766c4c2e64e3ad204d499163e3451b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af89f5457561abccf4d0ccc45f8d54e141766c4c2e64e3ad204d499163e3451b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9ef6b0b7ccda47e8ac25d7917c1cbc00b4ba4ccdac7a3342ea80be31261ea5a"
    sha256 cellar: :any_skip_relocation, ventura:        "c9ef6b0b7ccda47e8ac25d7917c1cbc00b4ba4ccdac7a3342ea80be31261ea5a"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ef6b0b7ccda47e8ac25d7917c1cbc00b4ba4ccdac7a3342ea80be31261ea5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e6d854ca3dc786f5e94fa25ee2797452573b70add9a1fc63af0ed4ef8fdeb2a"
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