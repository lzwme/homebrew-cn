class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.1",
      revision: "18f981e04b092593cb12a4d6982dfd19deca758a"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7a3759fa319cd30acf000a2ef6705cd8a80f5d65f5826b541026052e006c930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25da429874d74bf5e24c6ccafd53cf273829e83dfc18a1367f4980d1415f63e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96fddeedb2de4b9e8cd1f01aac0a07cfe0b97a1e5015a2c425b5f5b2797a5b4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "35db4a388b82f3ffa19d8604938d13031ed05a2a0c30d84b19a6b239f83684a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93883b697c66bc53c0d2540f7b599f6c70852e1a92ffec23ddea0af07afa2b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e511bc3deb9fc35c38d28ff5c961e8083ae8cc5824d4d3190b7de71e23c0564"
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

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end