class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.29.4.tar.gz"
  sha256 "3dc463c6cb1432469b3d7f0876c68913133d9cf5c2d157a22efc8503f35a4315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f5495eed9719c0cde403da450f84d10bdfee7a91a83544448e42eac6e076670"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c7b230b0211cac075727623a9005c22295c5d2d32331c6aaafca21559297e0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7a5535d9895a3129e0ca39619e8cee4f9b0a997975486fbbe76a57a5240feba"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf2f5401d74dd852367c9344eab4500c6fc185eaf0d55806bed05c2cc17d8c88"
    sha256 cellar: :any_skip_relocation, ventura:        "6b1c9b003e02895b391a0e047c51055691307cae31db8d2d699126528c47d9c3"
    sha256 cellar: :any_skip_relocation, monterey:       "05853c368a63418518a814ebd8ce94e318adc1403267748127e50bf244701fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d892451eba35b7910ef34ec4af12f400bdb6fbd83b29003f585f19275fc498"
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