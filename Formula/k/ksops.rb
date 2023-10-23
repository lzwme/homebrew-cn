class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://ghproxy.com/https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.2.5.tar.gz"
  sha256 "046a052d3ed0115279f890ee9bebac50aac51f70e426b59d428a6ad67505990a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee7ee45614dd6917b73b2f54ab665d59579a9d7e0cabd21512d36da10667a73f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d885fe7c8ff87e97863d204612c8d7616edfdfac89a34dc125b6b94f20fe153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f46c03c02184a357ef0d0d182283a3afe66410770ae850e72c39a5dc73c9b4d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "05046deda89750fb4539ebf3f63b99f1ce00382fc60e2461d3c752edfda4aa32"
    sha256 cellar: :any_skip_relocation, ventura:        "9b95adb49dc3ec2db34914470c1503c408ecaa26bf32dc17283e61912266e2d8"
    sha256 cellar: :any_skip_relocation, monterey:       "c52a77d089dd53219c90812539de2d23227126f8d4d14ca2617c86251d3fa5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37c6249ddbc2d8518e67fbbd6844ca60e9a0c7d47ff266334c9e38f0fed482d2"
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