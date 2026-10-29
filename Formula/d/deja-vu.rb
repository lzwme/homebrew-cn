class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "577a7ed2cea7d98bdffa5c4daae4c43288a91d7d6a9e7c09377e18017d13b6d7"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "801f97a5150ae3b5d62b9863fe78d05b7dc74e3d6bed80e4f726c04833f68456"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "801f97a5150ae3b5d62b9863fe78d05b7dc74e3d6bed80e4f726c04833f68456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "801f97a5150ae3b5d62b9863fe78d05b7dc74e3d6bed80e4f726c04833f68456"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a89e0ee616ebc27ba3018b44187c5ce2d76f06c64744f036a2fedb50d1ea1ffb"
    sha256 cellar: :any,                 x86_64_linux:      "743b37fd347ab276e846bc5e0e7401a5d34e218f8f24934bcae950a914f4c4e1"
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