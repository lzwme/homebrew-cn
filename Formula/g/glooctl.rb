class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.9",
      revision: "2362f6f059c0c40a36cb28a893685530079dc631"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8edf3f77fc0f9c221c31627700423a2e0022aa0d33bc01db8a66f7a0d6d0629f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692ce7f0f4ce8dc8821e6fe0f5c2c1f4142e347ca689d415b2db4ce26571f88d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cb1a3b71debca242f96d70a6b19552661da0ed3db733542abe176d0acc72cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6f24fd17b1d0647453807ee176cdd09749432074b258cf011237c60afcd104"
    sha256 cellar: :any_skip_relocation, ventura:       "90426ae23d8592cc4ee473e6098e9680c525713c13bd9885f2dcc8e8ff97282a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056c8cac29d7060fd0149b7252e5310a36e5a5f098649fdac0c4f1754fa2bfe3"
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