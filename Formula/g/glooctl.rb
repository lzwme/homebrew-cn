class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.1",
      revision: "6c6f27208b96e8e5390c28499f7f8cbf39dc0318"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fc187ad88c7c8d4fc19772996d5719ad8c3931094aefedd9adf1d25a581e14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00177d1d630febb661ef2fdabb9d98ee5e863ce65f7369f589b5c8651c446ec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4bba2926a63d0e367e96f4a6a5339226efdaf581d974cea55c44240120d32c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "598e6cb031da758b538b177eaba9c60951dfac27203cb990611d0a824ea6862c"
    sha256 cellar: :any_skip_relocation, ventura:       "ace4625a22eadb49f9c84aa3723e4029e78742df2ebdd578c79152e7fa8d28fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77e39f3eb49e7907c4529b173ed1c2aa89d6ae832ee12bfebd7158bd30cc000"
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