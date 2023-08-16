class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.28.1.tar.gz"
  sha256 "db8ba14266e026dbbefcd6495e9095a41434e599c109310a6f493a6025a5a42f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29a4c2cfb5b4da661d5ef8082ddad25676a0f6b41fcf50d05cebf40129913012"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29a4c2cfb5b4da661d5ef8082ddad25676a0f6b41fcf50d05cebf40129913012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29a4c2cfb5b4da661d5ef8082ddad25676a0f6b41fcf50d05cebf40129913012"
    sha256 cellar: :any_skip_relocation, ventura:        "80b8857fa8621b33067cb397215ac1791d6d0f7a0284d74d8cecfc9dad59fa50"
    sha256 cellar: :any_skip_relocation, monterey:       "80b8857fa8621b33067cb397215ac1791d6d0f7a0284d74d8cecfc9dad59fa50"
    sha256 cellar: :any_skip_relocation, big_sur:        "80b8857fa8621b33067cb397215ac1791d6d0f7a0284d74d8cecfc9dad59fa50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49af2018b496146ca5e54cd4690e68b4cdc2a9decf6f0e7a199a1e085d50b4c5"
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