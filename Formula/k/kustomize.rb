class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.8.2.tar.gz"
  sha256 "b70517ccd6986c3ec19a636bb877da9687d3420216d359e26628e5e03714b758"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79ef5fd65d967d1ae54c8bd1892c961db7a33687fb1391b5563b43ba197f892c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "997387aa599105c5138f49b34098ac45295991beefadd92aae9e2adc522e4b73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05306d545d40743da0ef7cd63e672045f5a58f5028230e938df0a0377f5a03ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c40cfb3d515ba315f860291fe2f04db182cca444684c6f65a764c47c3464f127"
    sha256 cellar: :any,                 x86_64_linux:      "313151fce577d48cc310e845be7a56bed9001b8c5aa98490ea06cb0bcd14119c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
      -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./kustomize"

    generate_completions_from_executable(bin/"kustomize", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~YAML
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    YAML
    (testpath/"patch.yaml").write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    YAML
    (testpath/"service.yaml").write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    YAML
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end