class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "f5e77b7c6de0c70cc78432a2d920ef9354a91c563b09ccfdda4d6af41900bda1"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a3ea425d5f7495d177b92b85838dbb0836cba90ee758cbe4ddc5c138ff502c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a3ea425d5f7495d177b92b85838dbb0836cba90ee758cbe4ddc5c138ff502c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a3ea425d5f7495d177b92b85838dbb0836cba90ee758cbe4ddc5c138ff502c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dafbaf53d3e900e3de8f4d53f8c98dd101a92e67bccf7b8ef81a61afdcce42cf"
    sha256 cellar: :any,                 x86_64_linux:      "e7056f7ac1876fe4143a32a557ac9326f51fc6add01d69fe3f0e58f8ccbe4048"
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