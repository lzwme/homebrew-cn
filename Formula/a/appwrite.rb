class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.0.0.tar.gz"
  sha256 "fde62b48a9df1adf85d25f7d6a1b970fc10277f021dd238a010007aba67b33ee"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ce7fe1234216aa49f80fece2fe2708d1a528c639d9351315e8b134c9c408d99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ce7fe1234216aa49f80fece2fe2708d1a528c639d9351315e8b134c9c408d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ce7fe1234216aa49f80fece2fe2708d1a528c639d9351315e8b134c9c408d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bdeb607b3d482b673eb0b32803a96749b230991473ac42d78b38b0ba864284f7"
    sha256 cellar: :any,                 x86_64_linux:      "d4b01d62fe9ee3a033f8344b51aee1b30a55e0206daa515996a484125b4321f0"
  end

  depends_on "go" => :build

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