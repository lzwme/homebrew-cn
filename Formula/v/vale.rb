class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "510145bbb23977b2fe923dd285d4512f27a2c34148744a2d4e30edfe7d65cc40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b706086a93207b2ad2a4670d40e2084829fc1c0d2625bc2cac59205392fa8c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c75bb70fc7c5e72902dd30fb8e3e6007ce5053bed39b74dbdf0655147145b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af699b4dc2bb3fc25b8ebc5d08280a834403e0002d66235a15bddb3d4b99e1b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4cb6efc240990eede6e94f2bd4bde1f76da8a45e21ad44928d26a0fe8d7776b"
    sha256 cellar: :any,                 arm64_linux:   "8ab8f41f7d79a1be2244c4384d5941aabd51df5f263efa2b321b3a0a53a05728"
    sha256 cellar: :any,                 x86_64_linux:  "5d0a687402ea7a7a675e1de06e19a7a638dc6e6dc626142d1936d525540fa249"
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