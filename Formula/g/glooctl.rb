class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.7",
      revision: "110cc22034ece5987c50059d33768389d9a35b36"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9332064637f0cc60ed652c0ab97dbc2b3b78e2ff0938617281f1482cea5b41c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcbfde9d530bd029050209f275672a9cef7eb7409202282232b9f09f747499e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "febe5361c9f7eb6c2a5a3725fc8f690db1728b4ca1d121c4a76f6c1a50a60b68"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4c10c4c3b2b8fe25b96b931f2ee87a8bc349ed42700d604ba07107e54f1a032"
    sha256 cellar: :any_skip_relocation, ventura:        "ff0ccf140e7d2979803984f8b4cfa9769087912db64a11b8877c9855486c518c"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab38f2631c8a73545ba3eedad46792c64bfe9b52fb6ce4fdfda20e2a91057d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ea11e33630c054e402444ec587acc2e4bb3150a662ab69f2970eb1cf23004f"
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