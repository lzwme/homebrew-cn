class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.10",
      revision: "c2fa2af8a45b9ab66f8f16e10d818a37dcbdf591"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79ee92df5c4fb94cd4bd61fbf2721448b3c386e7c4d91dd25c4122f61f9f7b6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eb4a09f9bd73b09dd98ab5bc95d5925f445315de89b489144a2130dd7ba1abc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23b30a776ba81e2d0f8eaa8e4624ccbd0b0392310a065adb8bb00317974ad5e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f49e37a00c86c22d3d0a703f2229156e0140e10f5794f39781b0aaf8bd982ea"
    sha256 cellar: :any_skip_relocation, ventura:        "1a57d0898db4c5664325215a46672319153662efbc289885c0528b67f5d7076f"
    sha256 cellar: :any_skip_relocation, monterey:       "315998008b79b05dface2d438d3d0814bda3f0d85724bf50e7be84cd77f2fc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e5cf1033a8702838bb727782ee1b91a74b0b5cb716594f6092df95cd2dcc87"
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