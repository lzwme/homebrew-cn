class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.5.0.tar.gz"
  sha256 "0c027fee9db8259028e06f28019079226ba16848288475fab981506fb9257060"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b83c9a9200dfbcef8557d352f012c84e5e0cb5da10a277e43348ebbd36b1d039"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b83c9a9200dfbcef8557d352f012c84e5e0cb5da10a277e43348ebbd36b1d039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b83c9a9200dfbcef8557d352f012c84e5e0cb5da10a277e43348ebbd36b1d039"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb1dd6df8c37e8f2b74543f3ebd11ca691bf02d6aa323e40a7fa25f56f681a3d"
    sha256 cellar: :any,                 x86_64_linux:      "47926bf1163ba1d4fe92253e2f6ca18c02434ed0a617c229f8d8998553632139"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # `go mod tidy` needs module metadata beyond what `go mod download` fetches
    system "go", "mod", "tidy"
  end

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end