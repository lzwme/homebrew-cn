class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.5",
      revision: "e46a61b7cf05d3c620d3ffcea7185ae35b8fe534"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99efe018641e3bc870fa8f8fafc39d6559b15e3546fa7d68a205868a158ef3f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d8cafa00f904740d2d990a4729a1ad9ef633058bc46e47491c4ac973d22edf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "167186ed1aac89edb9b84cc555653e27b3293b061c3dccefee54c6a23e21805e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e51b76b2bfe8c669a125aad6030d01a43dccaaadcabda25b9a3e121311d12251"
    sha256 cellar: :any_skip_relocation, ventura:        "b5a169375dff33a643d2636710b35fd4eb70b1b0e245a5ef8df5d8ae353783e8"
    sha256 cellar: :any_skip_relocation, monterey:       "9339005bd06db7989946e7dfedcd89f72b679a757e4ae9e27464d37d00543150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49903ca34f4cf2c452437a33e1510dbb14a0f5abc202cc9f3bd5b958a4684381"
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