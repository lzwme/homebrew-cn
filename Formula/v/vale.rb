class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https:vale.sh"
  url "https:github.comerrata-aivalearchiverefstagsv3.6.1.tar.gz"
  sha256 "545e71c16270af5badb90b4dd3e2813ec5372adf6bbfc935b552db16f9c98582"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7d8415ec0f64476e1e0e5fec250565bbc7175eff1618b5e28277511c89a30f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48c556e12bd9b3e27339c05a963ff842fbdeb06c64b9a79887c7aa5c6d954479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6454aca4eb71e9827f1aebbe869436d1c7cecc364dfb69a7f69ef1887f2920f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cae4969c0355b2694ac9eadce70490c9f37a81255c5c487d99c08ba2a065578"
    sha256 cellar: :any_skip_relocation, ventura:        "e0d9a98ed2ac718cbe38c53f3a5b82830a2da32a1982af888fd56254c989f017"
    sha256 cellar: :any_skip_relocation, monterey:       "8c33550ecbb31d25175d1faa8609da8087e66a1629ed71d0ccbd5bbf7dac8002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a83bc60ab6d08eb5f96fe867064ea76d45d6e2a33d79828690dc3881ff4620"
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