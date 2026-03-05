class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.36.3.tar.gz"
  sha256 "373a6ba221a141b213bfaaca7b343c66432e8caf241d15b62a6e9b84ea5d866c"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a834c2f1ab59a2b47e53c8b244f5157921cca5d75688c890b9f1f5732cd1212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12d5aa64ce0337b824a0b0d30a7c90f486d510bb74e78635bc8e0dc4789c04d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe9779e26fca0a1eeba3c0c114a3d57dab4062a7590aba51572d74f150d68bed"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ee514733d7d35b68569c917fa72c20118edcbabb119f90fed4cd1ffc2443e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac4f14cee920c5c6322632028d95a660c0941eddf08bd94ebb0b4464714f270c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cebe4a3a72b78c078f9c111b66f09ad9a1a8aaf056897e59a84ac983b34daf7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end