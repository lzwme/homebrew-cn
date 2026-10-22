class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "56546242614ccd2398d1779e590ed31a12b7b3d5a7755dfbd1f18003ea165618"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7520a032e86d703845364ba03aca8994a336fc066290d22a1dd7ba02be660572"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7520a032e86d703845364ba03aca8994a336fc066290d22a1dd7ba02be660572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7520a032e86d703845364ba03aca8994a336fc066290d22a1dd7ba02be660572"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ecd88b7a2b0d3e97c42943de4512b3cfd6a7a0d3d622ac526bea5fbfbafe46e"
    sha256 cellar: :any,                 x86_64_linux:      "a62d0dc63ce51a254bbd9e20f0ca17bb71ee62bb42af200b9413573937e71039"
  end

  depends_on "go" => :build

  conflicts_with "deja", because: "both install `deja` binaries"

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