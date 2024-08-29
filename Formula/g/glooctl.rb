class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.6",
      revision: "e80ece5271527deac30c79be26f851cf33903a83"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eec7a9f78a7f644d404e3e608b374f85d92f2333636b1b5373f0caa9c3c984f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2721da77d99eb5a369d729f4643a15083fef76fea352ef9c2f579a4358a960ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22008ea58ad0e1beecee27ccca52bd8e1ca385b323d14cbb27aeb4b2557af18d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc053785d39a5d71d3dae123c05030325a0f0f029d2844a8ad902d603a377b42"
    sha256 cellar: :any_skip_relocation, ventura:        "ddf1affa5540343c8aac44614996ef56bcf39a1bd61182f96e9ac35302ff5b21"
    sha256 cellar: :any_skip_relocation, monterey:       "5899f9313466070c30ecf1de55742fdd270fe21082f397d98ddfa6a2259f89b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0d317b3821570f17ef7f3281b5b49e744bc8e7287d3864ba51ecd0759833bf"
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