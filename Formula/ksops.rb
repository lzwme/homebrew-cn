class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://ghproxy.com/https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "2e24b1943788ec319a2ccb25cef87965cf73f21a052d0480ec5103f640e3c070"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d933331ae3f45d7ce93efdd3a6f3ff4291fa50a650fa6697abf8c8cd826d4f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d933331ae3f45d7ce93efdd3a6f3ff4291fa50a650fa6697abf8c8cd826d4f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d933331ae3f45d7ce93efdd3a6f3ff4291fa50a650fa6697abf8c8cd826d4f8"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7c1fdc3b26e21a1a6566a5eb7fb9cb713fa9c45b79366064275cabee241cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "1b7c1fdc3b26e21a1a6566a5eb7fb9cb713fa9c45b79366064275cabee241cc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b7c1fdc3b26e21a1a6566a5eb7fb9cb713fa9c45b79366064275cabee241cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4852cda99872d690827b81bce381d035e55db28b5cfa56e0b8b49b871365bf5"
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