class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://ghfast.top/https://github.com/storytold/pdfcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "68405d6c694fb4fc14e583d9e3726e36f28719857ec96b9c5a225da711a4f2b4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af379d17b443eb443f567f4d3f708f42b78ec9a792af8c718bdb28f9e184ac6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "186575ba2e7bd94f28663276eae20b57ba098813dbb3942617d218239272b90b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70efdbcfc1c130d2d4e34e6ef950ad68140522ed6905a49525610062c5630cf5"
    sha256 cellar: :any,                 arm64_linux:       "06edfdda2b2e7d333657d6b2dd5ea8da083f50e1fb105e2990f8ec863ace2cc0"
    sha256 cellar: :any,                 x86_64_linux:      "96205164886a6b0883ff800e2fbce43a0da8870b53313da25f82d1e5e1195461"
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