class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.139",
      revision: "9547a1abd262f49d5f3aa7d41ebd0c3a91776377"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686cca6a37d367fb94d4653dce3b46931ecd1653b2256002b30294a8ed0651e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "686cca6a37d367fb94d4653dce3b46931ecd1653b2256002b30294a8ed0651e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "686cca6a37d367fb94d4653dce3b46931ecd1653b2256002b30294a8ed0651e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6edd649a963c192b130acdc06f08d27f2b5194664d66643bf343baf6c40856cd"
    sha256 cellar: :any_skip_relocation, ventura:       "6edd649a963c192b130acdc06f08d27f2b5194664d66643bf343baf6c40856cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "711311b71335213130bdd7880fbf8acf8f5f0a2f6f5643f356b932c86c996644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c37712e268c85fbd4e4156c4f607eb774112e975a5a5d55721f0470e203eed"
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