class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "65011c76019efa20bef7315214f42cc0b1cabd1eb9c1caa83422dc101bb9b5f5"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "632a95b8c4a74dbd3eb239a64e84860dc7a99eb9dcb28cbc70726d5e19eaef14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f5f2881fdad8c7b34447c93672374cc78f1d4de7403654310781b7da2a16517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcb43c9e54b1d030c24147690c18ce538de38f5cf275d5a74c7caa1f4b185326"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d4170ede6ba5ef536ef9331800ad63a83070ffca8145fc909c372e74ea8d335"
    sha256 cellar: :any,                 x86_64_linux:      "823c8e27433325bfe691fb66c57f4b66ff50ef883f88f86ab3233a5bd1b1d791"
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