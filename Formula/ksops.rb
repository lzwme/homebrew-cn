class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://ghproxy.com/https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "91a22ca021a781b3833e153bc56eafc2f8c8fb5f44707672cec3588f0f1a32ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8a3b394ab9ffa9bb94cc61df88b66ccf40a5ddc966b598ad500d458766984fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a3b394ab9ffa9bb94cc61df88b66ccf40a5ddc966b598ad500d458766984fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8a3b394ab9ffa9bb94cc61df88b66ccf40a5ddc966b598ad500d458766984fc"
    sha256 cellar: :any_skip_relocation, ventura:        "63cf63a97eca9a9ecf109aa0a1f7d0795463f491875a9d6cfdbb5138831326ed"
    sha256 cellar: :any_skip_relocation, monterey:       "63cf63a97eca9a9ecf109aa0a1f7d0795463f491875a9d6cfdbb5138831326ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "63cf63a97eca9a9ecf109aa0a1f7d0795463f491875a9d6cfdbb5138831326ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ea2d6a5ace77cdbd55a44b972faecac77e3bc9f9ffd5227bf0b7127d7a655a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~EOS
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    EOS
    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end