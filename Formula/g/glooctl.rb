class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.8",
      revision: "e658203d0a0b7b479cbb59cfc43832699d25fb1c"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b50005c579b2404f812a658531e2faba3fe736b48c593ce0b876d7c6b956956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c8bf3bc70e421455168a6cbf49b1d4e93c1dc0acd1a7e78dcaa8ab044b3f94a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d47901a39fc1ab8505509853032ec8956efec81861bdb3789d0a23dba23c24b"
    sha256 cellar: :any_skip_relocation, sonoma:        "123aba43af83ba9e9be6cec49a8af62e8150d25c2f277942986bc97fb2e8815d"
    sha256 cellar: :any_skip_relocation, ventura:       "158474b096d1d0920f052aac734966c56bf994227a3f40dcc35e4e89c17bbe24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90ebe4533b4c095bfbc762d5b0a1f7fbf22add3f66f57770ceda896a7578f4eb"
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