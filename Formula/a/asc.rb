class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.8.0.tar.gz"
  sha256 "202a2b57b536e10b5d565e08052126fd58265cb213e7592f6ee9949b69e75f3a"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2042a72f930fbf33ff2eb5f77e33c784e61089804fd3c1dcb2e5ca9ad6a7d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a2722f1cd1070e8d1845dfc3a733ce462cceb78f1d8d73630d0728f0032ceb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ec4707cd874678ee37f75d95ef32dc1baea808015d369c2f02ab8b9dc819fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b782e95e57800a9b4e80eff529120742eee993d43ef2321eb0e3214c1058b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c9ea3c919f4e564ab4b35ab083c66a8d7d8d195c03c139933e2fe40ae8e97c3"
    sha256 cellar: :any,                 x86_64_linux:  "32564567d5496203a4c48666a2054baf8c8b6de2c731e7a1c16a8b9e882ec26a"
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