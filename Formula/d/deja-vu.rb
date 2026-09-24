class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "c21f20bb2c0fe7b86c81a3d424246a495fc0b439fec92d27dad0c049b8e89465"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2675ecf1ac560b5deb1c851346041733b6003ae75d0501ac76f3ff75b590bdb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2675ecf1ac560b5deb1c851346041733b6003ae75d0501ac76f3ff75b590bdb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2675ecf1ac560b5deb1c851346041733b6003ae75d0501ac76f3ff75b590bdb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ed00338f026894f285143b2b0221381e5d3c7bd2f439620869b0930579a6245"
    sha256 cellar: :any,                 x86_64_linux:      "60983f193aaefd2e9994152ea69ceb439d61d1cb2ecece2cb2b4826bafb0a9ce"
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