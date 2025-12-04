class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://ghfast.top/https://github.com/kyverno/kyverno/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "95c236722e8cca0fc7a0da8640c42f5df6cec8d9da91cbf892ab27d2a1245251"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2ed9cbf27d9a5f45203e4a7a0fde6e184ad31fc4928c1434141a3d57d5247ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53d6d3a36c44b2e3e854e285d0d5b6f00d59300a5b204d2d16c642f36e28640f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a93b62e8f76f6d351559beeec9beab6eff8e794e494c7c8c12707e02791ba93f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c598f42695ac7b59cfb499a7d538f7a2bc9642517c1eaa36c8c4e58565291ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37d44014ae683f2bf3138112d55ab8a294a7b1139c1066e2d18fca720f8a819b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c291ee518185309d63e924685331468f880f4ce6d2fcb514a8a17d6e03c61a71"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end