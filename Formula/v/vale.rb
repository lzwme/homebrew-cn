class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://ghfast.top/https://github.com/vale-cli/vale/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "c3f19654f140a59cacd35205d88fb52367f77e13f3c95472ee371199477fe076"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd4b76251b93c4e100a3587652b9c4b2f5d9f17e72c25ea8fb1688daff3513a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5711dec2b9437927460412ee3031d31312754d435b75c9e2866e89ef05530b23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d871c6dce553fd3cdd6e8c7c8c74448aa7a422632fdd6fcfabce2ac7cd9421"
    sha256 cellar: :any_skip_relocation, sonoma:        "d43bee234865d7acffe955566e9bd73e113df19d55cba7c2da3d708c54da75b6"
    sha256 cellar: :any,                 arm64_linux:   "dfe138b02211f0d38e16fdf99802e2c1b6ab402b99add59d293b6fdb997dd046"
    sha256 cellar: :any,                 x86_64_linux:  "08dbce5f64efe22cd9ef0ea82f0d7c93578715c9845e77fd8a66be030ad774e5"
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