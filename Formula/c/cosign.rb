class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.3",
      revision: "3f32cea203c59a93323a6bebfebff03417520143"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05e43eb63610a560ec54fc07258efe871992d388a1228145b9b490825f4c7156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25392d9b659dba84ab091283fdcc7fbc24677cfff856fad59ad042d74161045e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23122795e41f3f33cfdc01a8dff9f241c2dd26d522ec633ce1dae576652fcbc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cbde869440b8310f9625473453a373fdf346615ba2395c5cb0ab977d84c9aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868625c57c447b7b7f2aed816c835588801debc5614bad695ee88c6757849a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed86050a57597950e0559dea5bd45675b3980caca91a218ee35b0d343741e968"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end