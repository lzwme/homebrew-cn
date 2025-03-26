class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.93",
      revision: "35f2ff80e8f7168530289e6c6cd33233a0a3d91e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93dc4e636c2d0b8e229a2f49d1a6144601accb978f9cd00ad2f70d8985e5599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93dc4e636c2d0b8e229a2f49d1a6144601accb978f9cd00ad2f70d8985e5599"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e93dc4e636c2d0b8e229a2f49d1a6144601accb978f9cd00ad2f70d8985e5599"
    sha256 cellar: :any_skip_relocation, sonoma:        "42e43544a095adce6f2d1b8afbc15f6b917095d219e5cc8be7dbc63a895ca72c"
    sha256 cellar: :any_skip_relocation, ventura:       "42e43544a095adce6f2d1b8afbc15f6b917095d219e5cc8be7dbc63a895ca72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aefc57073fa3f80c44913359033ac42eb18be4a97fab90b0debec5ed1a94eaf"
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