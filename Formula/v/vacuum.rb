class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.35.7.tar.gz"
  sha256 "267cc48335d180878400bb6eca4d15c2561cdeb90d43a9f6c6f572b2a160c9f5"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb1c397288e8ac150ddc0cb5d76b715193ae17751c9641ee5f2c356cdfe8770a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11980746f017ca7af42f0f2c4b03098e37f8a314418f456f38b3cfffc2c37df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6830cac7a51d06878195d255781c3f7f5e06042a33772b27e5598b886ca09c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d07a84ed48705b28b877771db6c85268770a9bee5d2a1c3dc9fca9d88b83be72"
    sha256 cellar: :any,                 x86_64_linux:      "b26b58331d37813acce39c09d09947a8a3d33f76e0eef19db23010372d752fdb"
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