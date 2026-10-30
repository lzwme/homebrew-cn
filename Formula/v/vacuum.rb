class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "7d437ba614dc47e7be859d8b483f25c8e988c10fdc539135109946b7c8fa80a1"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d041f3fdb1576fdff5ef485da40cd6bb4e13ba59759eec74443a1f1f98195588"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78a890825325cf5cb78a19e5063f7f35f6956ac6616eea8b8ae5d605b1243d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b253a244471b0623092b67d2cf249fc2670c4ef2a0b7d222e8a6dc6a7bc8b55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a338f8de1bd551962142c7b6d540edf593c94f6e6c1ecf07080ed544eeb891b"
    sha256 cellar: :any,                 x86_64_linux:      "49f38f6c1b61e839d37bfb5bf0eed7976c33df5568525df0ffea8b09415d1536"
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