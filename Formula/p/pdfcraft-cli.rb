class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://ghfast.top/https://github.com/storytold/pdfcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "8a5ce106f7d344e8a4af569fd1fd8316277b380ff57bff53028edf02f607d6e1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "294de432a155c44f155c74e6e1c94e5ddcb61251abea08ffdca4aafade928292"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7a3cd3c08ede16ae2aefd2f23a3c633583b576b8f29a02e4e1af2a6fdc0837b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d743bcd5487abc408807333fdcbd1934f59419ffef6b8fd09a58ee8afa0592c7"
    sha256 cellar: :any,                 arm64_linux:       "58c168a8cfca46b9ae9fe4f0d9f60b6aaeb1d897de476d3928a0ccfa884f2e84"
    sha256 cellar: :any,                 x86_64_linux:      "19344b6a0dda5217715182af7fd71344e4981deb494ee9385c8cd09cbd17e4b1"
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