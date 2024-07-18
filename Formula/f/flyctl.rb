class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.91",
      revision: "63f016d98e7e0d4f0954e0a2a18bc682e8b0ebe3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9193ded48a5a9951e54003ea48602d9ae119a1f5707aa016af17034fdab993d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9193ded48a5a9951e54003ea48602d9ae119a1f5707aa016af17034fdab993d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9193ded48a5a9951e54003ea48602d9ae119a1f5707aa016af17034fdab993d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fb69b1f39462cc4aa96b3dd7c242cbe752cfbc4d55600ec8e763cf69eae897e"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb69b1f39462cc4aa96b3dd7c242cbe752cfbc4d55600ec8e763cf69eae897e"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb69b1f39462cc4aa96b3dd7c242cbe752cfbc4d55600ec8e763cf69eae897e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd94c58400078817d48d97a651bc06b0867b5c4f4bee77eafa35dae2854ffe9"
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