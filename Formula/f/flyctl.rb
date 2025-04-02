class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.96",
      revision: "6c2bd743048efc1fd7ef883f4246a1714ab838dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263645a1fd62cbfadf60b5ae6beea39511d9cef3de46d9d1f4c729d410ec8c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263645a1fd62cbfadf60b5ae6beea39511d9cef3de46d9d1f4c729d410ec8c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "263645a1fd62cbfadf60b5ae6beea39511d9cef3de46d9d1f4c729d410ec8c10"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c3e9f75a755598464c891129012678dd4973bb88885cbd6004491ef6953c765"
    sha256 cellar: :any_skip_relocation, ventura:       "8c3e9f75a755598464c891129012678dd4973bb88885cbd6004491ef6953c765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "050812b1f336eb187ae8a92a03c5a327293400870af5240f279907a4b5fb69d8"
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