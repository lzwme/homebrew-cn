class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.43",
      revision: "b5bfa8f464c5b27cd0ef2959733ce16849fed95e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c12144d6b7afb68889a0b7947315bca8d1dae462a66c9e10e5b6a16b1c00084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c12144d6b7afb68889a0b7947315bca8d1dae462a66c9e10e5b6a16b1c00084"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c12144d6b7afb68889a0b7947315bca8d1dae462a66c9e10e5b6a16b1c00084"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f410b2e80e342c6f600f66b2e2f4fde584c4b608a01eb505c7193544f048ec"
    sha256 cellar: :any_skip_relocation, ventura:       "83f410b2e80e342c6f600f66b2e2f4fde584c4b608a01eb505c7193544f048ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc7b4234240d76ed2147e5805532f287cb70decdc6c96479f8611309c57c6db"
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
    generate_completions_from_executable(bin"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end