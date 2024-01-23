class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.16.1",
      revision: "6c5c4b20af5c8dd5a362ba6ebbe858a80391904f"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1bf7b3125c131edd6a20cedf23997c43f2c81822bbb1d44da247125a7f7cba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0781822f2b328e9dd2933753b0c1cb4b865e5640ce5859f6d7cf02bc4b23219b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4896ab8d985bee205b9e880d667a772055da7a41ee05a5af78ac6212d26220"
    sha256 cellar: :any_skip_relocation, sonoma:         "d961ff15def7b133d0598fcc9a7d4d231e86ba797b6cc3b49537c4ef3c747465"
    sha256 cellar: :any_skip_relocation, ventura:        "d624a0224bdd0bce4b0b17c31848e7bc66f2faab6e308966186a710b4510d877"
    sha256 cellar: :any_skip_relocation, monterey:       "b08f2c7764dd17d7c5eb1eb9f7cedf5c05a9800366ccdcf4c330212fc8075dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da3d0cccf78099781e94c89e002096bba6584eba81087cc3dd085c3c83216dda"
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
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end