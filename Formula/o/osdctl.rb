class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://ghfast.top/https://github.com/openshift/osdctl/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "e937eacc5310940b652db3ba68c38ec2743c923a41bd9fdf9117d645201cb3fd"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4ede149a6dba96a7dd271f4234e3ee3e82bdb0764f467ee3c985429476daaa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ede149a6dba96a7dd271f4234e3ee3e82bdb0764f467ee3c985429476daaa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ede149a6dba96a7dd271f4234e3ee3e82bdb0764f467ee3c985429476daaa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ff810eb0fa361792f6bd97507eb5d8382fcca7ff8aeadbfa3b41f458396482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "056383ed6cd2dda9747806159670931a340f45ea6b2b7822aac29d3218f428ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417811c38b935eca5236dbe3e06a393a284055b3b270e212156eeb0dd3b7b83a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -s -w
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end