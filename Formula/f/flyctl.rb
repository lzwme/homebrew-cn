class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.10",
      revision: "fb8153e0478281c49f278373fd8ee2001d2b5adb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d0162da027ca7748feabf8456a5adf2ad24d090678e6ed728c40996db1d1251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d0162da027ca7748feabf8456a5adf2ad24d090678e6ed728c40996db1d1251"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d0162da027ca7748feabf8456a5adf2ad24d090678e6ed728c40996db1d1251"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fd41cf4fa50e66aef34cb005a449f9d2fbf61a870ee4a318c4e28f097842f2b"
    sha256 cellar: :any_skip_relocation, ventura:       "9fd41cf4fa50e66aef34cb005a449f9d2fbf61a870ee4a318c4e28f097842f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69721d24555ec49c4b1f0a6ceb549485a4f5c0ce71c222173c7e8783ea17bb8"
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