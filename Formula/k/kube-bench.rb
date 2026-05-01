class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://ghfast.top/https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "461f4dc07e8c1f3c93049b5344feafb7788b88d69625d23ccdea6610d55d4f4a"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4cdb30940f22e1db02616ec9e63f9d9cf98ed5f89df10f48c2287fac4754263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4cdb30940f22e1db02616ec9e63f9d9cf98ed5f89df10f48c2287fac4754263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4cdb30940f22e1db02616ec9e63f9d9cf98ed5f89df10f48c2287fac4754263"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad2e4ac25428aee0e5d1da547c1fa8883c382b24ba9b1c51f7b1117aff437084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "310e45e29f8a0eb970dd8257981aeba816e9bc9a586b27f370b2b6dc8a5ace27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24c3bf71bcc2cc29c6762ff3ae8d2d76df349cedad3d5626ceee38aafcfd1b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end