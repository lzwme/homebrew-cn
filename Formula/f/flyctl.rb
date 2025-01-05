class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.57",
      revision: "26a778ec23ba74394cc0112a009b5b2cb7e09352"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf580578b358d81915a71a89a3e1d1e51625836f3fbd8b4d108c3d3046fbebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faf580578b358d81915a71a89a3e1d1e51625836f3fbd8b4d108c3d3046fbebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faf580578b358d81915a71a89a3e1d1e51625836f3fbd8b4d108c3d3046fbebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb529e6c649e8cd1be5dc315ca9e58dda0268e4924d795d231b02ca4f1cea0a"
    sha256 cellar: :any_skip_relocation, ventura:       "ebb529e6c649e8cd1be5dc315ca9e58dda0268e4924d795d231b02ca4f1cea0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4847bd804aea04af49a5460339071b2455a9f0524d0a410dc48a095f315ad9be"
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