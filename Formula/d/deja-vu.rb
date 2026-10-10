class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "aa19f99818d187237007d13d0268734a7fb1c61b59990fbcfcc3860da85fe25f"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17be0899b5cf48553f7e4f8c2b5873e43a133ac42a2b27d36b47d32adc160836"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17be0899b5cf48553f7e4f8c2b5873e43a133ac42a2b27d36b47d32adc160836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17be0899b5cf48553f7e4f8c2b5873e43a133ac42a2b27d36b47d32adc160836"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79ba59385742772b3599f6e91302463c8ed556a93e861bc5ed877599a04b4aba"
    sha256 cellar: :any,                 x86_64_linux:      "daa9ee2b2c42545a0e2e867c5e7ecc9c2c1aaa5c855d402e861deef4ccb46923"
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