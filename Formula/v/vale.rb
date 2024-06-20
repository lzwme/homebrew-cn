class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.6.0.tar.gz"
  sha256 "28c0b97eb4af84c8997eef32de502329dfa8d3a8a41945de6fe13022ecf5aaa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f81ddeeb38565fe872dfb59c97e4739104dc14dc9042f82fa872aca20a91011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa408eb9bfa78cd4a7b184a3fdb8bb44e7f5d5e4069a68446d9b162c89bef9d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16fd86932392d6dbdcecbfe7c240ec5233632fdb2ddf578b9498954481df7ea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbf08d9f732ada93edbcbfda82b902df7b391c26f77d1b6d5ce2219db3c20e99"
    sha256 cellar: :any_skip_relocation, ventura:        "4e59da45786e1a65a134715c9cabd2b859ebbe04713fa18663bcc15ccd89b145"
    sha256 cellar: :any_skip_relocation, monterey:       "a9e8aaf2d0c7e01617bf59ecca0e14cc32596c324b79212456ed787e0435e865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0276f295aa5b390c9b02eb32e16f2db123709400dc6651c0138d5f8db5087c5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", ".cmdvale"
  end

  test do
    mkdir_p "stylesdemo"
    (testpath"stylesdemoHeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}vale --config=#{testpath}vale.ini #{testpath}document.md 2>&1")
    assert_match(✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\., output)
  end
end