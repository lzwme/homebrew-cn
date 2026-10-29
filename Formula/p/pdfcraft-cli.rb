class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://ghfast.top/https://github.com/storytold/pdfcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0e20c8675238a7576883587db144fdccfb968504101d79f82be436a593188536"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d3d4e4b3b972dc8da99f8dea32a4ac97ed3500a4d203232e783ca84fa6192a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf9571a51a707d3e8c1b58ce46eab3c583cc2b0d670dd8b7228560ca03a9f971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5afedc1bbf583b4eef270285d4655893160cefc9006fbcf95b7c113b60f7e447"
    sha256 cellar: :any,                 arm64_linux:       "46b61136a40588c540b0ef17c3fddf98be28e6d2833e81191ac4c025e73bf01f"
    sha256 cellar: :any,                 x86_64_linux:      "07cc51ddec0254b89b7b74ad3ed4592d9ad00450efa1c4087c1512c1f1c3e7e2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/pdfcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfcraft-cli --version")

    pdf = test_fixtures("test.pdf")
    system bin/"pdfcraft-cli", "edit", pdf, "--rotate", "1:90",
           "--title", "Homebrew Test", "--out", "out.pdf"

    info = JSON.parse(shell_output("#{bin}/pdfcraft-cli info out.pdf"))
    assert_equal 1, info["pages"]
    assert_equal [800.0, 500.0], info["first_page_pt"]
    assert_equal "Homebrew Test", info["title"]
  end
end