class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.1",
      revision: "ac58c949844763d37fa20866a2dadb8805f7a367"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c8072f296281f4638bef7e64d31233cc616fbf1e5e05bdae60b09dec09542e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8b14119de1695dd9d8773e93e90dc06dbbfa6a7bd5a98ae1c018dc91cb61f62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd9059f5d07867fcb422791fcc15ac85ad43ea6f2e9b35133588176f2a77062d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe14ac8226bd5420e6b9790b689114964d1a6ffeaa5fece4920d7300c14911d8"
    sha256 cellar: :any_skip_relocation, ventura:        "901358d84621b956212183b1df4a16fbc34f2d48ca175f639d37b23c37b255e2"
    sha256 cellar: :any_skip_relocation, monterey:       "dd393a0cb0bbf99f9e4a6ce163bb4cdd9032ae755708662a3ebff29c8a5580e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71e941c41aa2242af7249f6da5a0a49bc3a2ad0f38824290f4eb3b20fc9d12c0"
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