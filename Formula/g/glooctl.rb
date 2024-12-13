class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.0",
      revision: "487dbe468c288be878296c1058877f6755f4af5c"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0860c3f5d5f4c995a0e553f8168ff9e328e198984a26b2f02d734ffcdee3ae9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b644a21b2a82790a423c6839870a93f1fc603ac4d509768651bb2643cf7b82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad1f551445d6c012aa269b93cb353f6119f22d648f1ab51c79fe76da4a47757f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c451dcb0b96bd0f1f2442c9c92350b483427ca3b014f621e8a82e9279bd6081f"
    sha256 cellar: :any_skip_relocation, ventura:       "906370743712f10dec6ca1aa5e47293ce8f6584522373c362b199e03da572e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb09929d2ec81ca64b443818777cb347c9788ab30bba865327d89bde7c2fed4c"
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