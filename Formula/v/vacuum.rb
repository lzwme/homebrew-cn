class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "9e39d260176f77868c7c97c745e35460af5c3380379915db2bbc0f60de272f84"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0396dcb97fd4b06c924cbd85d0e8fb842b9b02f3a3302ce4069006a41fec71a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8442838c79a38c7b92646f3f23bbb7a3dd305d5404b96caf4a9b1ec455359501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9893b2d40b43ccbcef72a4fb6ac46377d95d81bedb38bae80d91e0563e70b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48ab26bfb80fdd23788686803b348e3c3937ba2ac8fe832b24a5b2726ffe417e"
    sha256 cellar: :any,                 x86_64_linux:      "618e75198627354a747e8f04eac3db0ff4e392bd0fa5b63139d836ea9569d657"
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