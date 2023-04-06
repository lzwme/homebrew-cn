class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.24.1.tar.gz"
  sha256 "aa30f373b858803297eca1dd2f391e0d81453cd96b54d802ab5f5d926731db9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d94b43e31582df314ced6fcdcaa83e6d9d59e79c76ff0fcc4370aebda2cf08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d94b43e31582df314ced6fcdcaa83e6d9d59e79c76ff0fcc4370aebda2cf08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d94b43e31582df314ced6fcdcaa83e6d9d59e79c76ff0fcc4370aebda2cf08"
    sha256 cellar: :any_skip_relocation, ventura:        "6741c9a39ef6466ede9de29236312d7a273d43f3a84a09c6dca94479b79b2286"
    sha256 cellar: :any_skip_relocation, monterey:       "6741c9a39ef6466ede9de29236312d7a273d43f3a84a09c6dca94479b79b2286"
    sha256 cellar: :any_skip_relocation, big_sur:        "6741c9a39ef6466ede9de29236312d7a273d43f3a84a09c6dca94479b79b2286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d23f829247dce772c71861132830e46c1ccbef8f1c3ce6969fd5d9494127fabf"
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