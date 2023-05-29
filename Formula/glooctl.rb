class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.6",
      revision: "a6718abcf1d192a7b44836fdebf1770836433bbf"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64bb7413527f425ab8326e7dab8e3d528677b0deed50b8651da82020a6f731c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c8108567b7dfad147b957491bd27f64114544ccfdf5c8bb3a4299c2c4ccbf6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835ce521d72a8f3357dc0580c7e281df0b7f32c20dc8ff86dd12208e88fe6141"
    sha256 cellar: :any_skip_relocation, ventura:        "5044f66fd95679d5b607f8ca5a555fda96a0b42f8e11443fa4cab192d317efc3"
    sha256 cellar: :any_skip_relocation, monterey:       "471b5000596304fe7cf17fdecbacb9be76e5cf030e23a9ea7bf55c781069c10e"
    sha256 cellar: :any_skip_relocation, big_sur:        "52af1f569133dcf8518ab7e8b21aff4a2e402db855c9256e00b40269176239c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf69e8edff0d779887e159edbbeb7f0ee58e938684ca72ba58aa70fada73d72"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end