class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.39",
      revision: "b28c5c56d4986534ba25a5a34ae5d1952f2ca4b4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07953ce420c0e370b92df82c472d85b4e9279fda11bbad62851f703fc5f42905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07953ce420c0e370b92df82c472d85b4e9279fda11bbad62851f703fc5f42905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07953ce420c0e370b92df82c472d85b4e9279fda11bbad62851f703fc5f42905"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af38528752f9c1565190b18c125cf8892b207f27ac87bbef5f4f97e45765c8f"
    sha256 cellar: :any_skip_relocation, ventura:       "0af38528752f9c1565190b18c125cf8892b207f27ac87bbef5f4f97e45765c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8afcc86403f67ff8ea434eb1132e947658cae9084373e064619d7d3b4a4f9d"
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