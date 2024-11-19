class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.38",
      revision: "cafc23d0ce030323d9ca886790e47224493bebf6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ebf335cea104aac27abc63a72db0aa602bfface2cff8e44db69541a5e77877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05ebf335cea104aac27abc63a72db0aa602bfface2cff8e44db69541a5e77877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05ebf335cea104aac27abc63a72db0aa602bfface2cff8e44db69541a5e77877"
    sha256 cellar: :any_skip_relocation, sonoma:        "044ec0724ca03ce8e59c52660f69859d56e114a159e9ad276ce64a3b2515e179"
    sha256 cellar: :any_skip_relocation, ventura:       "044ec0724ca03ce8e59c52660f69859d56e114a159e9ad276ce64a3b2515e179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b439b2ebfedb0b9a1e7fb36c5a25d996bb624ae4fcac344ef7271c0909df71ce"
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