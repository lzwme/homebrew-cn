class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "13f625c6def25611fceca695a0e2057ff72ffec9f6af5b42636eb44e3cff0a3c"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c07f688f1eebe415bad78424eeb914e98b8237922c71c4e063095909c5723a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c07f688f1eebe415bad78424eeb914e98b8237922c71c4e063095909c5723a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c07f688f1eebe415bad78424eeb914e98b8237922c71c4e063095909c5723a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe9e4df6caef6e042eaf1a0145d67a8f01f1850f492046fd0780a2b6f743a4b"
    sha256 cellar: :any,                 x86_64_linux:  "5b34c521f466c0bff6eaf88da5394a3da8b3e97533179245fa1d7424e446a08b"
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