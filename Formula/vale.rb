class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.28.0.tar.gz"
  sha256 "cd69f33b0f030e098bd978f0a8a1becbaf432bd6326a12ee15dd3bf9ea051f67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee31ee268ab4246f44e8ed341d94636d1986ea64f60bce8518baa7120abc34d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee31ee268ab4246f44e8ed341d94636d1986ea64f60bce8518baa7120abc34d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bee31ee268ab4246f44e8ed341d94636d1986ea64f60bce8518baa7120abc34d"
    sha256 cellar: :any_skip_relocation, ventura:        "0b152c3b0d7fddf149405049c18dffd7219768f6dbd6f6e741fb0df51982b0c2"
    sha256 cellar: :any_skip_relocation, monterey:       "0b152c3b0d7fddf149405049c18dffd7219768f6dbd6f6e741fb0df51982b0c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b152c3b0d7fddf149405049c18dffd7219768f6dbd6f6e741fb0df51982b0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a06989a3e5d617e21e36a2e127c7a46e11f95ddb693217cde2734075296770"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end