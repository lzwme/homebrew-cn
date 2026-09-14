class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.30.5.tar.gz"
  sha256 "1d760fc17cdda585560eabef1be58476a29767bac0a1e27d22eb3e1c16a3359e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4f326ae3cd84c124d7a88b0023b6d76c947a80a6d8457dfb01039c5550303c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b47ce3bd2dcda314cf79e2279694bfa5ad8cb72b3332af6975ad79e30a8d7579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1ac96be51c6884a03d2a183bb8e94e7b0c14f417ebed01295364817f71342ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa3942b4fc7e735944a863f0df03eac5fa1f630936299eea37cb9a45d7cee199"
    sha256 cellar: :any,                 x86_64_linux:      "ee927a52866e80435090ac821efaf7c18e0ed744996de53c6a214f0fcdff8339"
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