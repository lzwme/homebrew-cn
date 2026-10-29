class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.10.0.tar.gz"
  sha256 "af7516b70a1b56ae18f2f5db7478063b9ce6324c8e12aa5e1a7ccd8bef90b428"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "543ca260dbb9162994efc1790898a9ae139fa260f89fcf88e3abc2d0d2af5fe6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "543ca260dbb9162994efc1790898a9ae139fa260f89fcf88e3abc2d0d2af5fe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "543ca260dbb9162994efc1790898a9ae139fa260f89fcf88e3abc2d0d2af5fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cfe01b14cbc51cbfaddda084f8676f7632d5d3805310cc88f300d49b816d21e"
    sha256 cellar: :any,                 x86_64_linux:      "6d4a4b95f97048af4ddc339146fec3cc1a158902df803f82a312b069c4f1c021"
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