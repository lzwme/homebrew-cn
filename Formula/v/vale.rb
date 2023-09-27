class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.29.1.tar.gz"
  sha256 "0d27ff83541d5a2cfabad46fcee95691c3691c79e6c595486ac48eb6ce9fbde4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "664a56addb3f480f6e91c79bc1065c68d3c857869426a93c718d9a4fc84b4d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad5a2ebd5a6752c5d62998cbeca2deb2d8ade4cceff1119fe367305bf3658b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e05bfd695d4ecda5817d8d3c0ef1e44fef30af3cafb34943a521254a2ec7e34"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9802afb4c2de66ece3e7e7e9b6d85be346f77e330b8fb28b5788dc972103db3"
    sha256 cellar: :any_skip_relocation, ventura:        "8af863a2fc2448e5ce6264c32b7ff44b6250763246d12782ae2377f63a6ca5ad"
    sha256 cellar: :any_skip_relocation, monterey:       "c9850b8ad6abdd9ab5e718150500f6eedb2d5089a5c41353f37bd878feb3dc86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fd23a41b92ea901ed372c097410ccce22cf0368056c644756816670be896c8"
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