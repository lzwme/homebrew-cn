class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.33",
      revision: "201c782c0d8d21c4a16ba1bcc1e28ea7e35e095a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21173e00bf1491b998d36339fbda31668790bd719782906503fddb47c2b06ade"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21173e00bf1491b998d36339fbda31668790bd719782906503fddb47c2b06ade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21173e00bf1491b998d36339fbda31668790bd719782906503fddb47c2b06ade"
    sha256 cellar: :any_skip_relocation, sonoma:         "509478ce71a97024194ae4b1b46ae6e9d25b9b2c12b4b296b58374525edf8ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "509478ce71a97024194ae4b1b46ae6e9d25b9b2c12b4b296b58374525edf8ef8"
    sha256 cellar: :any_skip_relocation, monterey:       "509478ce71a97024194ae4b1b46ae6e9d25b9b2c12b4b296b58374525edf8ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e5c0039ba1e1dd4b750398007df5aeb86249676107371939c7de9b94a332e3"
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