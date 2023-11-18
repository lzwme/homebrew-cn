class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/refs/tags/v2.29.7.tar.gz"
  sha256 "278d8d49cf42740c38c10254012bbaad01fcf1c628aa69c51c02788d1495885f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2cdbbd814b77eeacd73fff39aca873c87e308b33397aeb3eb8e6495294ae3bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "704a135637176aae0d199139f1d92876dea701ae8dae07631876afd1a49b7573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d6b7ab224409f8592c519991642b9e2623cd7ad41485498d862b121363bcf81"
    sha256 cellar: :any_skip_relocation, sonoma:         "91a37a0c1f78a323a22e410114d01be1c94f5176d64caff04707ec9f5b370cb1"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9228ef4307c5bf60d950e7a9786ccaff5e75de483ecf677765d0be6f03e560"
    sha256 cellar: :any_skip_relocation, monterey:       "86ed05da1cec7bbebaecd909176283f27f9df4b1ef64d008f0526c2a58454485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08143bd68a449a24e7bcd795169f4af91a94ccb01aee78cb560c8466e4e3aeda"
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