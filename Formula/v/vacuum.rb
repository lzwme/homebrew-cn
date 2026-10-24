class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "33d54819b8c285f094967667ec18e44346a8d95df44343dcc106d14e02da8161"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b23772ec2d6274404bc30abff65bb9561fa13073231113b79bcd06613116f5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "254390b956f3fd859d7d9b63ecb680b6ca5e7c8df221ebff5b486b9db24bebb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d46c00dd72d4b43b6e8b510f68624ed0a4f92a5aabd26541a3611825ada8aa26"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "edaa9e4a2a8921b802eb192a594759113e9ec0b55935a3cfb5eafa46da38884e"
    sha256 cellar: :any,                 x86_64_linux:      "728a41b64a0de6e82ea1347c6bd13ca3a8bac50381731f52097b86bb4a5862b4"
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