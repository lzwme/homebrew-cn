class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://ghfast.top/https://github.com/storytold/pdfcraft/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "ed738813ba7ef3c41930e215dd8ed63e2711abd335af9e57561974ba12998ad3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4bc26540967254620bbf63ee60a3f59b5412d4e8af282dc968938c45ac89f051"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6d264273987319fa4b9324e876aa60a472faf562f513508032f4eb451bff611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e963e229f55d59c2b19645c5cfe9f533bfab8f608ef60f6a6b16b999f95fe59"
    sha256 cellar: :any,                 arm64_linux:       "bdcfa0369757a2f861b0ac64bbc3b331c3e2e72ac19e6920fdfe33c3ce188f21"
    sha256 cellar: :any,                 x86_64_linux:      "57f8ae062f04c4863cb282b4030c427310669743c84394c935c163fd8541fb52"
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