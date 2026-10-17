class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.7.0.tar.gz"
  sha256 "6e1bcb6bd1c9960791ce3ad5faa0dade26edf9445c991aea2b753b0b24a70c76"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48b1b82b3012a3aa8f4f1cbe87ce0348792c9e90f82662a8988b5fcf6bb7abc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48b1b82b3012a3aa8f4f1cbe87ce0348792c9e90f82662a8988b5fcf6bb7abc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48b1b82b3012a3aa8f4f1cbe87ce0348792c9e90f82662a8988b5fcf6bb7abc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "627e94b1c26b3c7c58614005fbfae491601baa23368dd56c23441cfa2f1a6a36"
    sha256 cellar: :any,                 x86_64_linux:      "106d0a3dbb6ae2a98ae53aa7fbda7c8ec47ce73212f9c17a7d872082860f00bb"
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