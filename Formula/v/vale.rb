class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "b7aec3a7b869ed30e72f90e2acf35a3e2ee6673d3dfcdcebcce67928dfca1dd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19eadad47254c6bef47416261d010264a4e1ce92ea8f7a654d490ff4fb15b979"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b54115cfb0dde0c0c618ac4733c3845f89dc5388cf825a1d0ac2ba066f55a573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a28c1e0ce3aacd616b9ae1f52477937f9f8db33ded763daffd9cfd3ee783af1"
    sha256 cellar: :any,                 arm64_linux:       "27cb76c55b01975df510bec632ad5e2fab8f52dead6e81da029f6af567fde177"
    sha256 cellar: :any,                 x86_64_linux:      "f4a185a62d69c2f97d2102db7707762da9f89344ac4788447fce5488ba388340"
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