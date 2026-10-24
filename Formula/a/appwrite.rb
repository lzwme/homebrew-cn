class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.9.0.tar.gz"
  sha256 "f44c054f3e609cdf750a46c6e4e12ec3d37c4bad582aaffb2788be7f72bf3b6b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "302d3565bf42c83067023441d66c85cafef0f6cf045e72e2316c905d2e503896"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "302d3565bf42c83067023441d66c85cafef0f6cf045e72e2316c905d2e503896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "302d3565bf42c83067023441d66c85cafef0f6cf045e72e2316c905d2e503896"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f30c455f856786137f43519c6a754bbf20130426d1d774c2ea7f9f68dff0bf2f"
    sha256 cellar: :any,                 x86_64_linux:      "5a24a3cac2ae17d4df25777508861d5a13a9fc61e47cde0a0ced888342d6bf54"
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