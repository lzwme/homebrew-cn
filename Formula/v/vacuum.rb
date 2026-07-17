class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.10.tar.gz"
  sha256 "f050fa5d2fbde04632d0d413c82a0aebf26202e78e419baf1e24d01ddf8964d4"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc50dacf088d50445cdad2b6ddb11a9061c4aa24e26f77f42e550e43b16143ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b1d0e6c917018f972d3317e5dd31c684e82b116c5eefcfe7a0a69f18667825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94824f245a614938c4bd11ee34f8ca783ecef3093b2dd6673ebe0f4e7f4114b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "75aca3665f56af558aa7afeef27af89f371863c27564656845fb3d8467c6c7d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19b0b0221959919d1f335520c08c720d07c3057d19b40ae0825104000fe4c03a"
    sha256 cellar: :any,                 x86_64_linux:  "203adbe4b770c39d6e583db6f7da074f2769d3a79a64e0e67ef04065f17050f2"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "html-report/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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