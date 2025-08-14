class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "fe3149c6062b8d1bcb4cf527ea588dc8723dd1a4e067f0c76580819bfca5fcc1"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cedfa19b3f8361d9ecefc32ec0bc0f2f71e78fd7c727c0318b807b08628a94b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "851067d07ba59178af0f07cf4c538feeda3a4a6601acc966e2a0a84bf942cba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ae34831cb359f97a7d72b04d3547db58bcfaec79ec2c6e98884e5cdfafd2e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "e127ce62b70493a866c55df8711837c08d565b2ba931a58ca2e1fe47cd9994bb"
    sha256 cellar: :any_skip_relocation, ventura:       "ee13e64d8c8e2bc81069d63ffce8547596b5091720b1907d5032e19a077bb466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9a08455d5ea420085d0a27d9a8252a38296c0985724447ae22ec63f99f4ff89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96449b673a2c48ff3cce5c1f989a5d250167d6df3110414c64e9863d8d85146"
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