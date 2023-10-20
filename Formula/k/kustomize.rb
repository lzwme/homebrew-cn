class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.2.1",
      revision: "e71072b90b0ecf9eef2f2980765fc0b7427ab7d2"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3bc78b7eadd70ba181d4b3301141d8e0fffd946f94168958dc9637db577fba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffd8771fdae311bb369808ef10cb22a17e6da2563aacc843485bb5cae699d8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a72aacbd5b61176fcc34b6bdda9d846e774bf8d6dff117a8bc4d8eb7be6ce2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d1a60fba77ed962343e32a3a4674902b850ac2e1c9c6e1cbedc5db8af584850"
    sha256 cellar: :any_skip_relocation, ventura:        "334c1c43e847826f5de756ed3ed74b6dcfb86ed5b37d7384e99dffbd26b6861e"
    sha256 cellar: :any_skip_relocation, monterey:       "652393a36637627412bf0b3e60305c885c7d29150e4d00b55794ac7c4d1ec363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "721a423c7f71c03e050148f7aafcbee936b6c3ecaf642974cbeb8349f20b360c"
  end

  depends_on "go" => :build

  def install
    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end