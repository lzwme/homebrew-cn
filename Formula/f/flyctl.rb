class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.41",
      revision: "7932d6b6e8bf0e0e6518a0a5034f687bcf3f2be7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e3ae76ce059dbb4f0afaf117a183c526e895953a30288a4ddb671eab6ca471a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e3ae76ce059dbb4f0afaf117a183c526e895953a30288a4ddb671eab6ca471a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e3ae76ce059dbb4f0afaf117a183c526e895953a30288a4ddb671eab6ca471a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bcb53aa6712e8389a932330830d3d82c93d8cdf44af95458897a52aebed6a44"
    sha256 cellar: :any_skip_relocation, ventura:        "5bcb53aa6712e8389a932330830d3d82c93d8cdf44af95458897a52aebed6a44"
    sha256 cellar: :any_skip_relocation, monterey:       "5bcb53aa6712e8389a932330830d3d82c93d8cdf44af95458897a52aebed6a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27fc35c205b92003cf992e3fd83d85ca199e4f71f628768908b71661d93f47b9"
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