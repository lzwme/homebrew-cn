class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://ghproxy.com/https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "f3d1eb070661a339f1946800ae125729a7cffb7f6f2d04476004891af6968148"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa625c8942a8b539dd04d99a5ce979cd7ed0df56c3cd83b9253c18e9b786cc10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d40c0adced8550b5ebad438e66ea1309447eca6b91fa23ee000a317551c408b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bee71e09ae9162984a9eb2a9aaf88a67cfce0b85371e28d6e41bee6f8172705"
    sha256 cellar: :any_skip_relocation, sonoma:         "5feb3ccbffd97cd9594c862edd61e585333d8a456cedf5bc2ead8b8759898949"
    sha256 cellar: :any_skip_relocation, ventura:        "dc9d775d5cbd208b8d0adadf6b7b0466f2cbaa6b3a3c2ddfe6a3c60cdb7d1bf2"
    sha256 cellar: :any_skip_relocation, monterey:       "078c8c864bc6ead4d6aa651ffb4d6ec61995b8ca65ed4ac5b8380fb3adce9f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d37a1fdad52dcfaa48890f7ee197b14551024ca0876ff8ba6f73356599277b"
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