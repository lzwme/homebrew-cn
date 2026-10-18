class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://ghfast.top/https://github.com/storytold/pdfcraft/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "64c32b6cdab2d6334d16ac8c65b3425718cb88594e6347ebe25efc1aaf5e0bae"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd38267707fea1af551229fae26e06a99f14b55985d55dee652d3ff8e3f63a54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06bc64031a1386591d2749c76cd7aa7680a2592e5ba0a5511144c10d7d9b572f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40d4c00c3b2aa27511c7744f1d6362e18dee1113049955d1ead3aa99e8a1643e"
    sha256 cellar: :any,                 arm64_linux:       "f0f62780a0da44bf1bcc22480e942e45f8ee8e9073ea267677582914dbf88ecb"
    sha256 cellar: :any,                 x86_64_linux:      "35c02a802c5014968d74109a3d5759a595717d65ec3a876188f05db3514593c5"
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