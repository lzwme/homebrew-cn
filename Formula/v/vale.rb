class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.17.1.tar.gz"
  sha256 "4074a365518200d15f517fba83d97eeabd9d5127a80287089fddcb8fd50e3ff1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b29a823de136589dc8f42ee8b8aa03aca13561cefbaea8689ac58ccd706bc570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9875b7fd614c5021fefc091bc19293417b14fe34ad96a86b58f2ed87e2e9abb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c76d6f2a954575b02b94b9cdd52bfb022dec7e193cce5d48a56b244469c0c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "556102e1f8ca981d61af355064ac2b6b339264446ac03690b03054e6e799dcb8"
    sha256 cellar: :any,                 arm64_linux:   "8efda87dd22fd2ac71cdb9c06c17f2921a314acf2520ab18a1bec29ea262a386"
    sha256 cellar: :any,                 x86_64_linux:  "9b8b69e181fd147c9207cfee0d37b7141f0288a9a1398f1d3b250edfddb4b2c1"
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