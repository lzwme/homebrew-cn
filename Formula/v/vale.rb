class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "11273308a525c63c5e2adb0b12b85db0df33ce7507bf3248e2c4131d1d23fcd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaed4fa253e8c1c7a32e913b1d0b8da09659fa0ce567b22824172fc3903cc5d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8118fe09cdd2b12fb28dd6a36da41b1ae10f3f02041b3155a3b0880f27f71dcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c38df5f5299b8027de181d40d819dd6ebe656fcbb98e023bc367ea24a058783d"
    sha256 cellar: :any,                 arm64_linux:       "a2fe495a20ca9c320fc132c6c707a1c79556cdc7eef4e1e1174f5725812f91f7"
    sha256 cellar: :any,                 x86_64_linux:      "d7456a9b77ef885063abce90eeac357ff35ce45554251287691c668e83c7493e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath/"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end