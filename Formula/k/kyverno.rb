class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://ghproxy.com/https://github.com/kyverno/kyverno/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "274531150780c0ff0645c8c609448318a4c10f1e1bd079658186ee3dd28d8e05"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "103d585269545c16bc5bf7ef508cd35ad5400fd6336a29e1007d285ea646e610"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9491c82251ee86458be0f9c1b57b4faf152fac6feff400023c7ab122ebed393a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed21d6a3d5abec7bebc96f6fe4ece9fee88557561b0272898ffc889f1c93f0cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "30a0a8853ea61ad6e46b4e4ca3d2c10db13daab1e791421325af1d69fabaa983"
    sha256 cellar: :any_skip_relocation, ventura:        "3eed510b52b47eba5653b5da4bede6aef9c6b8cd8443f8953f1df8e656a894e6"
    sha256 cellar: :any_skip_relocation, monterey:       "e318b6f953bc8e907a77d8aee05d71d04d206f9e33ab6783bfeffb169ef99463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "957bcfe25023b66d773009a013002523948a55bdc7a72973aca50b9720340f01"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end