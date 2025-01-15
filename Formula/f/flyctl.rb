class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.63",
      revision: "15a12e6d5c3f4cd06a08bf94fb17c27c1df76d16"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9a31d48518621245e8f32b80d9349d75429256aeecd4b06ee2ec3ccc98252c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9a31d48518621245e8f32b80d9349d75429256aeecd4b06ee2ec3ccc98252c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e9a31d48518621245e8f32b80d9349d75429256aeecd4b06ee2ec3ccc98252c"
    sha256 cellar: :any_skip_relocation, sonoma:        "284ee6b9188b2dd316c650c84bdfca5fa93b17d11be4da7df9c772ef62f9ca93"
    sha256 cellar: :any_skip_relocation, ventura:       "284ee6b9188b2dd316c650c84bdfca5fa93b17d11be4da7df9c772ef62f9ca93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0084999e63b6101ad93cd3cc37b1d59dbedf29a42b640c223391e4161b2231"
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