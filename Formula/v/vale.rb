class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "a0110585b20c9f192406fa91cd08bdbf604ba0f532524de8185a83e3f9d0e4ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32afa77150d313795fada826777f5298c8663f84f05f799901c5368ce8e37b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e86f5b6d8026e9f8b6b863e4d27e7dd6103f2cd19964d624d1322878ca19119b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53a5ab7e16c3382375efd756f9d70df3c7397ce62a54148fd4900be3429c9d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f548b9fc5d15d895bed20f462e19f78eabba1b410e9c5b624a183afff6095dde"
    sha256 cellar: :any,                 arm64_linux:   "f3a04154e7a3e0737925dff50dbe75da0e2fad018dcaf83ca69a71531d5e265f"
    sha256 cellar: :any,                 x86_64_linux:  "8e55faf4d522a8b9fbad7db3adc21dc6d3ca7881b0c6807ce31d3278c2c1eef9"
  end

  depends_on "go" => :build

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