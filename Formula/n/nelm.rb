class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "5edba061d008204ade64649b3291411c5fa1eefd92593622521ceef80b2a8376"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af1d26fd85144f6f717a2f8b51496b8d3f19053d6aaedac24015c81c29d40c94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "006eeaf4ed2bacc6e122629cf4b2438b6d1121db2a51125bdafb60d4cc29073e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f201a49fadd6831e622d8fba20c8c57bb52bb023aec89b016530a928bf5f532c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e76317197fc1f53422cf5a892cd3881ccf917807dc9dcc1591254a8b2f32675"
    sha256 cellar: :any_skip_relocation, ventura:       "4de6814a2c3ac47f9de0d47a243ca1a7f89fb69f4f533a22f7bf09a8665eefd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e6ae4938898d13bb19a18e6b54455acb1aa5665996bd77e5184190f4bb49b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f61c7de274c053843939824c7ce461f0039487d91ebd738babc09a9fe81f5e1"
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