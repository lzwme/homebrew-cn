class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.5.3",
      revision: "488ef8ceed5ab5d77379e9077a124a0d0df41d06"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd49a4c20c608cb060bf2ea3d00720082f5760b465fc8696114a02c5cf622b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5931809ce86efe0b1e2b5acb4ac5bbf4aaad246b37a88ce9f1e0103667bf334"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f25f17c836689bc962b56970ded77fd2b6754f9cc68a0c8e960eb7a9900b8f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "1adc48af2c7bd3f8350382023e4cdb90426b90d40f912956a64eea1813d9f8fb"
    sha256 cellar: :any_skip_relocation, ventura:       "a157131e9188d7712225bb661092f17a313066036c66d2470f9329951b3da861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "844a8b301274da1d70f6fd812f2c96a855d88025387a86557ef64017d55d0f18"
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

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end