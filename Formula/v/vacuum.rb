class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "5cc85bc6fdf05780301aad8ba0512b36004216f73b99ba6be59b2373a1fa83c8"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7820dce9df6884102f55a65e19914c5a067cd65b0f59baf685d2be678dbf01c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e5a467e80c56164c727f97326e107f9387689ae8084cea60c60d3d53437b04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f4ca61b0de083708d28f11688dcb9acc62a98e867035dac288a2da5161f248e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08c75942b635cc2e695e38518f9ae9bebcb2ee8515f22d0351c6cad1da1cb258"
    sha256 cellar: :any,                 x86_64_linux:      "ec2b05a3abb4dee11a1986ec8aee267e28a990e481b44231febdced3d1d35b58"
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