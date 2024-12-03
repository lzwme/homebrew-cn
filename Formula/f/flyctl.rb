class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.45",
      revision: "d36714daf1a0bc2157649365827093e0948d9b1d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "448c0d5407677072fbc9b84ffe313c2c343f8b9af34200ab3f4bb8e4b14a3681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "448c0d5407677072fbc9b84ffe313c2c343f8b9af34200ab3f4bb8e4b14a3681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "448c0d5407677072fbc9b84ffe313c2c343f8b9af34200ab3f4bb8e4b14a3681"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9952af5f7a7fa497d9c4b84f32150a3277d2832eb40209d866457317cdc1358"
    sha256 cellar: :any_skip_relocation, ventura:       "d9952af5f7a7fa497d9c4b84f32150a3277d2832eb40209d866457317cdc1358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c166e65329aa7ee08cf43fa21f4e1abee5bdbbefd9408bfd57ef4fe3dd1c32"
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