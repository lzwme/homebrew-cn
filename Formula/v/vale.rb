class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "dc6459f68da7bb82dd9fbce449a9a67352565f7751dbe15fb9912594984c6a4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "922d004b1f8393855b3db4a7b823ae700e22f205f4b49c1e398fb39d2fed8553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8204de4f23fa69f704b12c78e3df944dac15d17b8731a3d24f8a1239a1fb733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6497d96903080c2c2064333cd97b1e5c57c86448bd01f1fd2bc2d1565927316d"
    sha256 cellar: :any,                 arm64_linux:   "b78e3a672bd95678fe50dd924c7d280d22ec198aa392517d45c537fcc6a02beb"
    sha256 cellar: :any,                 x86_64_linux:  "a6f923858ac76f3759dab0d3fd21b434f4f8435d03b0f947b0f147c50daf1f72"
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