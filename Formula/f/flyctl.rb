class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.46",
      revision: "65df1119742ce65d4ce99c71324702a61df5242a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90714c74cbe5656c17f5d1ff34b698f7d8eb0a424a54ed1889ccf19ae216b7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90714c74cbe5656c17f5d1ff34b698f7d8eb0a424a54ed1889ccf19ae216b7c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90714c74cbe5656c17f5d1ff34b698f7d8eb0a424a54ed1889ccf19ae216b7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b7de3da2e6243d4af5035bce6f93055e4883f2277ae7c8722c149f8c45f4b72"
    sha256 cellar: :any_skip_relocation, ventura:       "3b7de3da2e6243d4af5035bce6f93055e4883f2277ae7c8722c149f8c45f4b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65db15b0d44b268ec316e1e604cb24b06bbfcf733ed94260036048d64cddc06"
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