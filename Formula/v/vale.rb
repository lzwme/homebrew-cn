class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "5a355957a3b5da88a1b785d19dd9232a64a2c649ef9c95939cbce4b3f871e11b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7705e7772367c6d82cfd41dd0fe1662065aac1a50b3a35fa9fa58d652327d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f12ab9bf3e44bbca9c8aa65ea06058fba07c3d97739d9b44a041f607a9f4c988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df1119b58d493a2fa7087886587e8cf602ad73419c9307a18a3e64ce4f7e0ea3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1bfa5074b197f158b34d16a0b99a774469c01b261df0f12434e0fd8221b8c81"
    sha256 cellar: :any_skip_relocation, ventura:        "c95d989401b9bc4f7d0e1ee50bf8b7411fc6285c126ec3c6245a4a5eb2aba4e8"
    sha256 cellar: :any_skip_relocation, monterey:       "03c7c04cee73031c63520a208fa3d775ec4ebb776b7e8df79aedaf4054713e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539523fa46cdefe2a4aa752756f5724fc85dddce2b7ca1163fb41cb3c613efc3"
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