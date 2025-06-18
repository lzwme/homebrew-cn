class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.144",
      revision: "42cbb921deda9c446c6f7ea007a5f284c13afb8b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb128cf86ef2b3e8f789c122223c9a3d94c3c3fc96010a62347d43651db4f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb128cf86ef2b3e8f789c122223c9a3d94c3c3fc96010a62347d43651db4f6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efb128cf86ef2b3e8f789c122223c9a3d94c3c3fc96010a62347d43651db4f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "830d92a3cfc498001320b5b1b46864e43f3c31b64dc5ab67faa560768fd42221"
    sha256 cellar: :any_skip_relocation, ventura:       "830d92a3cfc498001320b5b1b46864e43f3c31b64dc5ab67faa560768fd42221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8388703be9d0592b8451d4a28ef84acbe1357d63d8bcf4b52c8e51a1a6374b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9736db31eb4c1f9f3497003da01a99c0c83d2232264f2f9987c87360112f48b9"
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