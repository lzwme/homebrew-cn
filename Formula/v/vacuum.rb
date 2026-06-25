class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.5.tar.gz"
  sha256 "f97a31f67b31bf3f941546705ba70c7f8f7f5d4db0af70592aca2d0c12ec6f29"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e77d69de70cccab31ade975ea1e3ecb7b722fad86ca0012c2b6fa0778b0f6d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b571666c94fd22f6067f34c62f3db76519a421b9417ac4b36863534cb6411359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b2bf63c93d481a336fe368ba2641f431356aa6f79afda95988afb15bbc9e10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b434424b22496a48e364c148fbd281ba0e4b8eea7b3a081a9bd06724a20907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd16a3010b1a59a03852741aeba9112fe8c0b3fdff45a0335020b77f2bda74e0"
    sha256 cellar: :any,                 x86_64_linux:  "2bc37e3abebbecc048e32e37423ddea45a9d11f6c2bd00d2201d50f53562191b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
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