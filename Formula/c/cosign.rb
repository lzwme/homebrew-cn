class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.3",
      revision: "3f32cea203c59a93323a6bebfebff03417520143"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6353eaffac9f90cd74197456a826dea01dff6af4529d6f87e101130be1e38e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5cf37234587d322be47d4dfc426420ebabc3f5ddeed78150d62a8664ee0934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c991d4f2dcbeb25a1fda9093eccc0c42d35330e20ee9cf46bdd0742f8df9a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ae19185f4448754b16241b44b0e2a000a82efde1b4a719452b5982cb20bff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0cb8bc803c38c6edb4916fc83035f1f886d0d725e3c5c31d3dfdc71d40b15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffcf3b6caf285df88ad2312126161a074b363e6cd7c673b572592dc1f0a80d0e"
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