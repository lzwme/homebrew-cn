class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.10",
      revision: "df90c9db78d5dc9730ce636b8c13ccae3d00090e"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff29be5386644acc757cac93a845f80f920f3fb8f554c8a1c395476577e04436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a85cdde02c7bc41aad5c8567fe3078c02854245655d119dd45afa70e8241fbf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a939dee9808f92e4c1c01dbe089b0592eebc2eef43e7cefe83958c5d5dbce34"
    sha256 cellar: :any_skip_relocation, sonoma:        "e46a08c9241facec895fbdf3d165751175ba736f43c85523d9b9cf82080b8f84"
    sha256 cellar: :any_skip_relocation, ventura:       "7b019395162209c17c10ca5630a11ec32801608ef9b6f3d56ca4074d33f84590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e59d3e49a096bbef6dab29fb65b9b22f32174e520f7a4da5ec411ddeaffc79a"
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