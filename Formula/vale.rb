class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.24.2.tar.gz"
  sha256 "c66d6372cd831842e75b25d093689356e599f38093e52b96f695e90dc6ebaf2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2835e8933d0374997589a5e10af23a7042babe3ffd87b9077ff8657f95e839e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2835e8933d0374997589a5e10af23a7042babe3ffd87b9077ff8657f95e839e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2835e8933d0374997589a5e10af23a7042babe3ffd87b9077ff8657f95e839e7"
    sha256 cellar: :any_skip_relocation, ventura:        "75f8107726038710735268574a350eaf5b76a862819520e8bc9f75cbc7fdf246"
    sha256 cellar: :any_skip_relocation, monterey:       "75f8107726038710735268574a350eaf5b76a862819520e8bc9f75cbc7fdf246"
    sha256 cellar: :any_skip_relocation, big_sur:        "75f8107726038710735268574a350eaf5b76a862819520e8bc9f75cbc7fdf246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4d34bce1fa6d7e74a5543d2a8e1bb900a157484836e4c124860beba3869304f"
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