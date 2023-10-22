class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.14",
      revision: "c8cbbe0b15f1021b98a29674e69f8cf247bf460b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d7a5164edac44d5266ca751f4951057c4e8eaad985e3a312f10c5e880dc87b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51b3b8dcf372c102c6088aa7eae1b0cdbc2e4dc66c61898775d84c49a83b52e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4020c60656241ec19439b963c797e7701798d00068f18f8519e539bdebaed2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c68fadf5eaa81100a64aa7f7b78912f9cfb644fd4a395ff1ec85b08ce8b069e5"
    sha256 cellar: :any_skip_relocation, ventura:        "1f300a6dacd1f8740fe15235bf566404574c1823dd1aef84aa11784261ce4598"
    sha256 cellar: :any_skip_relocation, monterey:       "115281b48a15da0342415a72559c0f371af74ec23d9fbd052c2456629a3747fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4342e09088448078254224b918f9a9d445d274b6b369fb5be93ca47647a16da"
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