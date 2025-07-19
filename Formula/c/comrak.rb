class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "89bf88ac19a0b7542048a78c6273643d25259acb10ffe22af3482ad8fd04f69d"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80bfde3c91ba5ba5ac9f1f9e6e873706e6b14cdfd9175b88f61d7b20473b4099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1381fb837112d9d841d9145a0fb34fe44e5098cee34bf0984aef6101ee455d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2082f9f1f8af84cee3e125e1c7b2733b26a9547ca7cb39f0d96ebd1e4b9dbdd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "27cfab0687ef67e035da630e570bf274a7e0062574176ce7bb15017f3c3fca14"
    sha256 cellar: :any_skip_relocation, ventura:       "73ad11973089ba5b53091b11c87dada330dfc355b88a758087749d89c6a3b7a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dabfbc0afb858c3097bc15ef8d1155e4047157da0e4ae8e3da1e22626707ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe506d45876ea993c38dc5769f5e3ecddff35624d46bbcff405306ef824cbb2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end