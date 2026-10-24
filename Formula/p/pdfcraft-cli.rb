class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://ghfast.top/https://github.com/storytold/pdfcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a65214953787fd8428cb6636447a0e65a66f20bb64ace18bb58e06d7002d7a5b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b095b0a63157675a614c430ec6ae603ecd4f53dcbc8dc7f608fcffcfacf5184"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "963027761ddfdb3e62bf925002f4d9bf38ac8a2ccbf151e12403f9f3732ebc07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae23a9af742eae458047bf7a30d752e03c63c542745563b60b770ef613ff9fb8"
    sha256 cellar: :any,                 arm64_linux:       "dd2eaf1a476af12c4de9e090fbf48ec854b5e6aa1d4b3bbbd736700dba95d74c"
    sha256 cellar: :any,                 x86_64_linux:      "b6a31a4ad07e0018050cc10c113ef5d898558ba46ab8a1ac39f1a69da5808dfd"
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