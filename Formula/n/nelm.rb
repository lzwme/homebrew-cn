class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "1ee9f1c80d0590b82277a14feb29b2c7b6c4e6893761a3fcd9394af5cbd1596a"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8111f1ba57cde6595815860790acf33bf5d773c7e9a495036dab51ff9a519796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d92c070dc114fb29d6082064b466bd292034773d6d6bda594dc2adc7313658a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f84242e42db99c685b81f2d2442c9bc7ae3cd7d850554c46aa7270373a55d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8813dd3cd0f2812ba95afa5c736c4735fdf66aa6cd25f587a88f27de0f7ec80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa07c6a5281022bd19f2cff62833c5f5b0730e7108297cb3c2a32625d89b64f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356e7ccc2bf31f2c14cd6d6bf83621557928702d5e864876bb49367bdf63d411"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end