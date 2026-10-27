class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.35.5.tar.gz"
  sha256 "2acee76193c365d169494edde5ed190c13280bfbf5493c8590ca453991605cc9"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e349cf505ff4c385e81719898108cb27020944066cdec409b84a2c755012450"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f756b248872603f49d1e6b2d7bae17f4be7880806a95a0e929c7e5c728a93dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d46b1ec51d7058f2b612ade6cfb199d385e6b248ad0c29f0a7a525d5c9ac5cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "365097c06d2d59266f211dda955c47fd4d1b5880b15d725bb95a2a2f6b7a9be6"
    sha256 cellar: :any,                 x86_64_linux:      "fce379d578ea28dca56d57ef847690aae263023c854384ee4ab7e2d9bd1ca6d8"
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