class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "6a403c74b2a88dc32245e08e0124735fadaa9ce7548e5c3526af29d80140ca85"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6934dd9cd657917c1da8a89f75f5c1cd6bc7231cbd328db729d315a1650ba69f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6934dd9cd657917c1da8a89f75f5c1cd6bc7231cbd328db729d315a1650ba69f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6934dd9cd657917c1da8a89f75f5c1cd6bc7231cbd328db729d315a1650ba69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3408c46cd4fbcdd97df8ccfda9072f01d702a2e4a4145b80a851bcf7aa72064d"
    sha256 cellar: :any,                 x86_64_linux:      "98478442b6f0b99ff8a5ce677d5f4a6095d73a6351c9f6347647e844fce264bf"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end