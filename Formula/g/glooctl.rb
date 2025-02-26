class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloo-edgemainreferencecliglooctl"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.10",
      revision: "0e847830a29274fc4ccd9985e575f1e0a6a5de79"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11dd0054b656eec6524c405c319121bd74fefc6f7d890780556ee2b56d72ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2edee66bc4658184bd97cf36c29b4b00fd05377575b3345d9def116a28bfdf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ed4f0bf01eb1a52d2b6d2618f0c9aaa1e6d133cbc9962c58cbf6072fcfb3b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cce0983a6743d11538823f649d11cec41eb3235b5f3f8a1641c49d21ce369f7"
    sha256 cellar: :any_skip_relocation, ventura:       "04c48f2b401ddd3e40b125b96296ba29a6a11b26fee6533dcab489cb4822ce0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20770e73559814727a6958c64c032723309b1ca9cd9e4a5343bc15d4ff5c6b42"
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