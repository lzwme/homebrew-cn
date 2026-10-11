class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "4a716ef1ec061fd498213a20485b56ec434417c19f25920e5ee1af067e527522"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "881f27d5d4ceaa6ca5f7bac35bf5e64b843732b3a9450fbf1b46200258378272"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "729ed7e05e2adb00a27de9834772c07e42c984d948b678d94a5a985bc25d824a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20afac32386c4fd0db37203fb04732d6f3ce318967cf53bcf5520f73a594f5d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe7aa95650a04a14ae28b7b337b294f2b4637be99d5fae7177a2a3f2e82cf9af"
    sha256 cellar: :any,                 x86_64_linux:      "1166b1d00524dbf6013e3698b27001471aebccd19e0b8e51ccfe3be6713fa9cd"
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