class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "1151d2fd8b14621cb4a5d594bd51e92eae65091bbf6955541cc6f88e7c7f29ff"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b3cd46afe413dc95b9a88ef192baa37fdb82e30448380b14e6162f1cfa67c3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b3cd46afe413dc95b9a88ef192baa37fdb82e30448380b14e6162f1cfa67c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b3cd46afe413dc95b9a88ef192baa37fdb82e30448380b14e6162f1cfa67c3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "404d014a36ceed905a278c95e24fc07c6a79cdbb92d689c2cdd8e6322b9fe076"
    sha256 cellar: :any,                 x86_64_linux:      "8f1afafb0e32079dd8e9e5b72130ee6c429fec31f89be798bff6f92f1e26d9d8"
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