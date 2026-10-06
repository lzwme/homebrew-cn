class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "bf87ce4c86d72db1bbbcf85f63cb6ed10f9d15ae8fd151a2959c2a818ec9cc84"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "168998ada265c557cf442727e848677e68642afea977629fe31d2ffa1874443f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "168998ada265c557cf442727e848677e68642afea977629fe31d2ffa1874443f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "168998ada265c557cf442727e848677e68642afea977629fe31d2ffa1874443f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8b14ab7f5edd9bc01820886db9c1388deece753fb3d5de9d4094b10de80c083"
    sha256 cellar: :any,                 x86_64_linux:      "1a7942ece809559e7264621984ae3fe7ad7dc695cdf2506e20c809359e0d71f6"
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