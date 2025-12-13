class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://ghfast.top/https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "447ce982e8103934c92a466438cad961a7ca3f817534c3b53c80b12929679b95"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8caf58466a34f0e8eb819cb3d7a3fc02dbeb64d4e2857ed490b52102d5193eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6924a82e503920b46e03603091e86474e9b263a0b683687719e210e3fedb6886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d719a91c18fb84bfa954d71d01b9dc592f2c5b1ca9f009e6424872010da7b311"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4719406822637d495b03e399015d5b874ace96fd2c25ff29bfecd6f88381a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a97ea2782cc52cbf4bfc29e09c7ce8616437d9356fcd22154677c5d6c11af959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc61e15b7aa0dfa19b57ea903ee5b0d31384fb663aa6e61a87315b4d644cb35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"cloud-provider-kind", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 1)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Error: please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "failed to detect any supported node provider", status_output
    end
  end
end