class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "4328bb8309efd671618c9f12bfd2cd4cc6deb4d75b4debb9672286d1618170b5"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d269216980e7fcadfa28618f96a2b9cd4f8919e7ea35f8ffbf04efc5bc3c440"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c1db861cec43ddcacae7ef827d287478d786cea598c9bb93c95d30832c500ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ccf34cb4227dcb5fc00cb4caf3ab5507567fe13759b7c2fce99979f2cc7f5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ef4fdc3230d143ff8e7b361626fed62b73b8bd4fff4c9a88195384f1f3cfcac"
    sha256 cellar: :any,                 x86_64_linux:      "58d0e8631df58596d3022ab9819462f19822d75782c9ca0b4b5c53d79d9ece21"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "html-report/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, tags: "html_report_ui")

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output

    output = shell_output("#{bin}/vacuum html-report 2>&1", 2)
    assert_match "please supply an OpenAPI", output
    assert_match "generate an HTML Report", output
    refute_match "html-report support is not included in this build", output
  end
end