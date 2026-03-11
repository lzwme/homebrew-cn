class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "20f4d2348befc987809f692e2d10e1c99a281061cec56edd5f459a3cf0016bea"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60323db0eac20fe3f961290d0ab2b1608d4bd025ce042c191c7570d60530d6d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02c834ae8f980669a851594fb1580934aeb7cc2e61c8af5ea3e8b442ddc4fcc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa46f237e4aab5837b89587b94fff6f8628d52b9b6aa90617ef0034fef787059"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e91b8eb023840253e667ff60f2026b4244ae842d6402d7fa3aa18a47aada156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b340bdd3b47145fb22ad9e1cc57d766690bfef9636302ca20b189d359cd5e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9b5d513cd2eb68059984c28ae70d192aa9b74893b00f75763fb0fb42095b14"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", shell_parameter_format: :cobra)
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