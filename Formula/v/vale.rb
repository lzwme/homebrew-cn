class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.0.3.tar.gz"
  sha256 "3cd9798922e46a22163f823b5b1fbe01a2295173f5edffe2c51b1f503885d719"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7955103a5191cb656392f59ad66414d6cd20e40221e4bbaf705217fcc14a6e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06b33d8c1d20214899547833dc6f6c780f4f343cd81ab86b8b03e744cb2b36d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dbc0ff21380d02559fb90cac561f750c8954278ab6b6bef45f8cc1aa684454e"
    sha256 cellar: :any_skip_relocation, sonoma:         "717d08231b897bfd858503d1fa950caea2488c4fc5b94c99e3750eb667a0b79c"
    sha256 cellar: :any_skip_relocation, ventura:        "70724ce34a69db97fd4e7ce40ae5d7aab27d06590a4a314f72cf88fffc6bdda2"
    sha256 cellar: :any_skip_relocation, monterey:       "c131bdb7c8d251615b1f7c843ccba344e6defb4bd011e3d835e077cd999d3801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2927e5f601043e429ca6c8a3af011862eb58000543f460c45be1202f12f0064c"
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