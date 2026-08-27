class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "183c732d48d8156508a13169185caa7dd1103f71e9cedc479c161cb60e2ea240"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872ffcec8e773c59f5259513f07b1fdfb83219fa67a192253935954b2f025253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9bfffe29c8125cd6308e559a4e16ae673f702a0424f6a9173a921d80e1304ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89cda6be4cd3275291f7d3121594c8764fda7ba4509899e4f6d251d426fc023c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fd3c5de29d2f06404672360ebaf2ae7ba9046aa48bfc79c606c07d47d93aba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df227e5d3c474ff7bbd958d86fe8aa638d5c3f5151c33af8515a674190dcb67"
    sha256 cellar: :any,                 x86_64_linux:  "d916a3902b50018aed3e968f6011d4b1f4722485d886207f057cd43c77a47977"
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