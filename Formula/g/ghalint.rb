class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "bd3c22fc58ba5f4a1546aceb373aaa1c609b902a874d75688be700bc2fd9c09d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e3e179f2fcf0e0831f3f13f7fa4fa2683bbbfb47faf1e685dae331d0eda175b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3e179f2fcf0e0831f3f13f7fa4fa2683bbbfb47faf1e685dae331d0eda175b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3e179f2fcf0e0831f3f13f7fa4fa2683bbbfb47faf1e685dae331d0eda175b"
    sha256 cellar: :any_skip_relocation, sonoma:        "01479ab393749b664a5e5a3e349726ca9447d41a3f596a0133262b6752cf36c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7e75a4beff5fa95e0d60cb1349329b4a19e01f8ef66108186594a35ee7f030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6aaeab36b13a7dabc95f4ba7700219fd8ccba540eacd178bbd3f7ba32f7399"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghalint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghalint version")

    (testpath/".github/workflows/test.yml").write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/ghalint run .github/workflows/test.yml 2>&1", 1)
    assert_match "job should have permissions", output
  end
end