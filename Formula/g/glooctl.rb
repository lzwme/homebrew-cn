class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.8",
      revision: "1a6a2d974e70d69759d5e992d1cdbc1503181cdc"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33791a604e3d1ccfec0e13a6cf1e052e90aa9e81d632b52d23956b5eceee4815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98a539a03903f2a3c0849b8acb10d5e2e0a9a1153bee24ac5c3bb88fdb1dc5d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25b32f246434d32d1e3d63078ae73881a8bfba6eada16ee5aae50844e9fd2aa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3288ac655faeb42a5dda57107867b65b5e808255be751a900e75328d2305b60c"
    sha256 cellar: :any_skip_relocation, ventura:       "2456dec37d2f5751c35d84e40e3bbba4d47f979e94b84d6c783eee7e616bc74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a69ea9c2acf96a130e6c0c9da335326cbfe670accc9d43c5d278e52fab30b8"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_outputglooctl"

    generate_completions_from_executable(bin"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}glooctl version 2>&1")
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end