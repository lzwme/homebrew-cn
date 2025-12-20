class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.5",
      revision: "2958882043c371a422c8fe964c4cef8dece7461a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7467d0e5a6f9ea55db4bbd5356f88e9861be49cddfbe551c3cceb37fbda75cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e210dc793018f7764108cde2a92e8795087f0eefe7c78308ab1844ba54c290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab0449d8d570f078be16e7ff9f464d4b90ee5d5198d3f53a63dbff67003ded5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a1d2e9ef48c0c3311ae05690228be4d9b6d2e5328b6834aa27426f9ae70dc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d90de7e5965a1f6330dc94e814ca7ec3a09df05458f938de3c63116b524479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5b3faa13a00da5d97b8815fb46943c7c679beea60b8045adf64e1800b9416e"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end