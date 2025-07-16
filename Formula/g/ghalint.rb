class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "b2d84de50610153c419cede213cc42f5cdffe24d380560bb9aa179a059bdd675"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "317e7abd55a92af01c7235f3c26f212f8418c2bd49947dbac88a2ae5472a5e31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "317e7abd55a92af01c7235f3c26f212f8418c2bd49947dbac88a2ae5472a5e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "317e7abd55a92af01c7235f3c26f212f8418c2bd49947dbac88a2ae5472a5e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cdcd34689302aa615b4a9dd2e5ac9ec43abc4634b0e6ba81a0cbb628c666181"
    sha256 cellar: :any_skip_relocation, ventura:       "4cdcd34689302aa615b4a9dd2e5ac9ec43abc4634b0e6ba81a0cbb628c666181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afbc13e24f391dc79582deeccd8b5b3f9f044714e19893f471c77188f26fcf3"
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