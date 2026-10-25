class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "f572128076db19c9fe008450d321bf2650e5dfcf9e54f363d9024978188f157f"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8538c25dfed9e5ea67a751d189f1be7c9d52a8d9b4c4413241dc187715965e5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25207f63a34ef66ede834e43866b743919e90423acf907f9a787b63681067f52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bae3f594056a8247418834782786df08a7fc13ef8a238ead972370b08ba2af03"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "440a59a8e3ea9935224ba90dccaad0957c5fdd24cdebc8d6dda7ace56d83c9ed"
    sha256 cellar: :any,                 x86_64_linux:      "652206b826b30e611b165689f0402590253813dfcb85e495dfc6a8901eec476e"
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