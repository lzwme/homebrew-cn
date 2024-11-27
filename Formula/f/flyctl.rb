class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.42",
      revision: "c4780b9cdb77bf0926193f20fec0425df685e3ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880108fdd4ec5e177d522c35ec913455a971d38837eea7ebb054677ef009a073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880108fdd4ec5e177d522c35ec913455a971d38837eea7ebb054677ef009a073"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "880108fdd4ec5e177d522c35ec913455a971d38837eea7ebb054677ef009a073"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b63420b77ba713d9a381df8c5c3c5014bdf048ba7d28510938739f8d6647544"
    sha256 cellar: :any_skip_relocation, ventura:       "6b63420b77ba713d9a381df8c5c3c5014bdf048ba7d28510938739f8d6647544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed157865c945e9646b3565faca038ad70d1075eb3b5612b0f6a6783b35f4cc4c"
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