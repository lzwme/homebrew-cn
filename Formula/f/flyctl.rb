class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.80",
      revision: "96f677794a5ae30a226425329b61898b83099d5c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11bfb331d0a9dca962e486a1dccf9e860852272f6524ac1d192667bb348048c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11bfb331d0a9dca962e486a1dccf9e860852272f6524ac1d192667bb348048c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11bfb331d0a9dca962e486a1dccf9e860852272f6524ac1d192667bb348048c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f32301a13900ebff7235d31cb59d259b32bce711ec5db0f0cf823c67542776f"
    sha256 cellar: :any_skip_relocation, ventura:       "5f32301a13900ebff7235d31cb59d259b32bce711ec5db0f0cf823c67542776f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ed55b225274f150c1b52364911e99640d5a5e88e992b4e2ed696ed0f75509c"
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