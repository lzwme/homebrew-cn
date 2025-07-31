class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://ghfast.top/https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "08891e25bfac225ac90fd6ccc20ec5d8d0dff96222d86eaafeb976d85bb338f0"
  license "Apache-2.0"
  head "https://github.com/viaduct-ai/kustomize-sops.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17343452def7526089b16ea57e32f01b1ba172ae97ec5d237733a366befae681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17343452def7526089b16ea57e32f01b1ba172ae97ec5d237733a366befae681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17343452def7526089b16ea57e32f01b1ba172ae97ec5d237733a366befae681"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd3f6dc2bfd4bfc5a8fc316bfb69acb96fff9e8e9ce6b486063fea1d22a0eda2"
    sha256 cellar: :any_skip_relocation, ventura:       "bd3f6dc2bfd4bfc5a8fc316bfb69acb96fff9e8e9ce6b486063fea1d22a0eda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4bdbb84f09f2bbd812a349633347fb8f7a0bacf0b1c236337aff59680569195"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~YAML
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    YAML

    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end