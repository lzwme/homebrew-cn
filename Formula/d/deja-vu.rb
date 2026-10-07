class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "bab1b30f0f3fd43c96efd87fe13272066ae04ae5a1d42b6bdc1dd4f0769022da"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8b33fa9859580578c9b4f95b390d6b877392307923b041c5a0dee2c4e022a7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8b33fa9859580578c9b4f95b390d6b877392307923b041c5a0dee2c4e022a7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8b33fa9859580578c9b4f95b390d6b877392307923b041c5a0dee2c4e022a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c8e8590a84f7dd57f5a2aac77ad973eefdc77d6438851265946e914f86a0299"
    sha256 cellar: :any,                 x86_64_linux:      "22e80891b894c639cd1d0443b5a4b788e15faf24c83a4116078baabd62482647"
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