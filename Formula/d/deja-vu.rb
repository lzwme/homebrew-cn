class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "6e2b51e61361c3daf16b1881878ba237e3a426920b5db0cc86696696afb0b12a"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5c398438f5fc874a5c3b49440b082c0e811ca434d127084a0b89614b29850e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5c398438f5fc874a5c3b49440b082c0e811ca434d127084a0b89614b29850e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5c398438f5fc874a5c3b49440b082c0e811ca434d127084a0b89614b29850e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e0b64d90c88533252a717900780426ee9c9665d9edeabd6ed4f35431e7e8fde"
    sha256 cellar: :any,                 x86_64_linux:      "fced9d675ebf75fee8c5deec995fbbd5a79a6bf723b8d21b16496e3c05850dbd"
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