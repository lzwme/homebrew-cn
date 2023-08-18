class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.16",
      revision: "cbc385911e3a21fc63480cf0bc9e77bcdd1c51b4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4bb188ddc97e15951f9462a8ac134276e842f1aab5e02672827d96eab980f74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2633701c0f5a8b4edc122f3154f0161d274424eed65e9cbc5de88b1427f0813"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be0bfd67334773783b92dfe418ea5e4c8edeb62d02e764fde671864dd7ffbc18"
    sha256 cellar: :any_skip_relocation, ventura:        "e022deb2fd17aa59f64d2431c85d8be9aa693ccf29727ba2257cc0aed91ffcff"
    sha256 cellar: :any_skip_relocation, monterey:       "5e8f7acb62bc07f381910ffde3894b394dbb6fae5124c80f93ce953a8167b6dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "71d895626a5c4844a0953f914b14c15c9d7a9e0bdafade4108012dbb2bf56802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef361aeaf60415f12b3996693ef4e8b3040dc759d4cd9749feea8d82ad8b0184"
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