class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.25.2.tar.gz"
  sha256 "a85aa7012bf058185f2d66dd96bc594b80303ebb56dd42add8f6fe3c948f2677"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd35bf864c6872f590cbc0b09f33bd820ea8f1f6e683c7e7eee2a8223dc7af2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdd35bf864c6872f590cbc0b09f33bd820ea8f1f6e683c7e7eee2a8223dc7af2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd35bf864c6872f590cbc0b09f33bd820ea8f1f6e683c7e7eee2a8223dc7af2"
    sha256 cellar: :any_skip_relocation, ventura:        "1e78c11bfd06f7470cc4d76cb6a5d70c87046502b7a9165138a4106024479db1"
    sha256 cellar: :any_skip_relocation, monterey:       "1e78c11bfd06f7470cc4d76cb6a5d70c87046502b7a9165138a4106024479db1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e78c11bfd06f7470cc4d76cb6a5d70c87046502b7a9165138a4106024479db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0109b0cfdb00a3dc1d1be9e5f512b4bac9c07fd9ef279142a32d230061a91aa"
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