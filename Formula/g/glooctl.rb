class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.11",
      revision: "b938f0d0519415e4f2263dbf1f3710e7d5bbde16"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86d75b868a9598f3e906f0d5d7483cbb04e12e685f7a6eb9432d73f8be994dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4e97f6f66134f054cb1fa6b2b3c1af2b34d2fc5fa8e18be4d955c673eaec375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0a774504e76ab4fc5f1f545559f4a05999723b2424c2fd2da1811b0945c7a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b3f758ff0ec6440b601222ab0cc03893ac1470925e2fbef55c4ac3bbbc4f706"
    sha256 cellar: :any_skip_relocation, ventura:       "8b35140aaacc6d0162b1890f51074276d9b0883657de1dffdc2d474d1470c920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28caba819b94f6c018b9f11f8ddf966688db8fe526194b917495790b9d394370"
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