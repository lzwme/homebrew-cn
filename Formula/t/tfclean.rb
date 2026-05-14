class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://ghfast.top/https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "153fac0c12ff8b09c7de4de233ca12126d90f80cb8f47f7db6729a49e88ba554"
  license "MIT"
  head "https://github.com/takaishi/tfclean.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec0704ff6e4ec265d53e6815f8185ac1f0816836e37cc1690459738b234a4c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec0704ff6e4ec265d53e6815f8185ac1f0816836e37cc1690459738b234a4c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec0704ff6e4ec265d53e6815f8185ac1f0816836e37cc1690459738b234a4c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2bf3a96b0a1ff87f12d52ed5644156af745ccefcea140cf08eebaf67c4a286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2147ef1f95a07035c68d19f3d0ac7fa71e4b04dcfd16a9e01257891cbfd8d65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36cb744e17a7434c7c84a31c8c6ba05fe5833a3ca0eb62dcde01eb66c51133d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/takaishi/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean.Revision=#{tap.user}
      -X github.com/takaishi/tfclean/cmd/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean/cmd/tfclean.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfclean"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfclean --version")

    # https://github.com/opentofu/opentofu/blob/main/internal/command/e2etest/testdata/tf-provider/test.tfstate
    (testpath/"test.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "0.13.0",
        "serial": 1,
        "lineage": "8fab7b5a-511c-d586-988e-250f99c8feb4",
        "outputs": {
          "out": {
            "value": "test",
            "type": "string"
          }
        },
        "resources": []
      }
    EOS

    system bin/"tfclean", testpath, "--tfstate=#{testpath}/test.tfstate"
  end
end