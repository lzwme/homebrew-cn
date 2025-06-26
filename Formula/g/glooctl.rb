class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.19.2",
      revision: "7ca3b633a3996a7626409c4311caeea111b752b5"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a650ded085bb69d3078ccd9f298215eeb8ae4709fd9f4daedc9c159b53731c17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7799a7a96f5bfb57be124d1cec3ce5cd05091afe4ea5b2198b20da75b05a29a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59ffabfa7600b0674116b7788b57b755139cea63646ad81e8145ef599bf54368"
    sha256 cellar: :any_skip_relocation, sonoma:        "daaf5256b8ce3b0bff4a507ca6b5e42e64c4f3b21fb1116d6a34ccb2a4d759b1"
    sha256 cellar: :any_skip_relocation, ventura:       "28f987ac2ca5f5860fa121e674db0f3de27eaafe025e7efd40158050ab207ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c882fed939c7068d7645531f31576b7ea488d2350c568010a61c523fb7e59856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd8e0bbdfc11ea530119b7b70a33a8fc5d3fd6eb3e111de55382fa9005b7dca"
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