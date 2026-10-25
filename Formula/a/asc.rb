class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.16.1.tar.gz"
  sha256 "a46062d376ea5dcdf91191aa4292ddcc78cf7a912b72d63b588baee37523bd42"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e76be292e3f1be475adac176226277c536c44e626b2519d63ed449173e8ae08c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36987f8b044212f0107fafba091936d11fbcd220fe9414980a446a1763337689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3700c17e94aa04c81bf6e5b84322607f19238a92b16c15a71bea5e963b47f09e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bce459fe8827f9bed3261e94d362b301e1df1c080ddd1d111a7adf9245581e94"
    sha256 cellar: :any,                 x86_64_linux:      "a1f83e25cdab696b7f8a78a56a007d7d8a8b0e2af6135fba98c80b9acb3e7509"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
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