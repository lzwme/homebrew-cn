class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.108",
      revision: "cf4a6690ad4a5359d6be480e385dac8538469132"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d05d02c7dfcefd018a2bcd9a5331f673975a9d16b6224724daa3cb7e9102e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d05d02c7dfcefd018a2bcd9a5331f673975a9d16b6224724daa3cb7e9102e8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d05d02c7dfcefd018a2bcd9a5331f673975a9d16b6224724daa3cb7e9102e8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d467d8f9bbbaaaf605fc9c866e78f6115ba951c670b9b175e43a1cd33241da05"
    sha256 cellar: :any_skip_relocation, ventura:       "d467d8f9bbbaaaf605fc9c866e78f6115ba951c670b9b175e43a1cd33241da05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d54d5f7a76bce4bad03f2751d5bb13054cb9032e847ba5579af7aef9e68e818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745b1835c1ae86a563b2b2d38c74783670778435d46910f3238c19cc84671f71"
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