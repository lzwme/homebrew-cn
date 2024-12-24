class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.54",
      revision: "ca535e1f38e3cae1fe087c01403c48043b96d801"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "742f6c9963fde1bb8ac5f9679ab185039e4736c113126a2ccfa44c0c8e5ec392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742f6c9963fde1bb8ac5f9679ab185039e4736c113126a2ccfa44c0c8e5ec392"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "742f6c9963fde1bb8ac5f9679ab185039e4736c113126a2ccfa44c0c8e5ec392"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c11198cd789037ba3cb4cf6a18e6c810765af5e74feabcfb151366b7052fa70"
    sha256 cellar: :any_skip_relocation, ventura:       "2c11198cd789037ba3cb4cf6a18e6c810765af5e74feabcfb151366b7052fa70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d149ea29c1253c657854e98b8d4ed60b66b0be7b7a5923818c9a8b0177b75d"
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