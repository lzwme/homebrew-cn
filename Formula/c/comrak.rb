class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "8f449284c9bbd67686c19e04d999048459188adc13f92f05467fe4275d4f866a"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2744fa5b4cc2fdb3b1007f3f40c27447cf2ecb39d4473058746fb857b09fcb3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754dadd62ff7d4dbe29f544765512674b2d8e322450a43653ebfd6012419f011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f7ad13d0e0743bba91bdd21c096afb56c44c5a34a4e2d0a4359a397a38b5591"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2c185f9fb7201cd79046466ba58e647d2707b0d941706f4e5ffe0a6fd7ebbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc087ea09803225ee1125ff6dc1a7fe7adbf3b066ab7e0034ad53562e105d47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d20ba08abb015c085b46566ceb25ff6dd3ddeaf76e6a759f1a36090b9c87426e"
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