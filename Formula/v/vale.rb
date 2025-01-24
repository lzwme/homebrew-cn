class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.9.4.tar.gz"
  sha256 "47b852a6cf88207af2899fd868004eab6b6bb8390d3bb56f452b92e1833dcc35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5faac14c2a392363b954e4c5bb28a581abdd62e3a3e1f19c616591b57f1bbbf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6886627efc62b0e2461b5675394d142c17ad8c4c14b23e2e97e131c869c65a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7874ccc557909e252073111fe5c2ec9dcece80cda98d389c91ca6f2742cfd837"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1d97faf57730aaf8898a12f35c4ea732ee307dd4b05c0cc90e0930a41866d05"
    sha256 cellar: :any_skip_relocation, ventura:       "07c93edf0e3559f7db56b6f3a31bc80b02a3ef5d94b0c34db0cd5b59a998f486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4334be6efeef09eca274e606c32ab7110db8bdf8fd8b8ddb01420e12c33fe05"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", ".cmdvale"
  end

  test do
    mkdir_p "stylesdemo"
    (testpath"stylesdemoHeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}vale --config=#{testpath}vale.ini #{testpath}document.md 2>&1")
    assert_match(✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\., output)
  end
end