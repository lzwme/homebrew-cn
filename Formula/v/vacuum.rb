class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "f17bca1cd74d14eee9fd80444eee8088a0e1ccb53b2b7359efb4906af3830b68"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c77e26e0fa7abe37bdb7e3541551ef09cd88bbbc2b0da56abaee602791962f8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca3f3bb856f9cd2e9c7eb306f2d29244227501a4c9102b2f20b67c8ed570e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2e6fb247b7d68c9d5e8cccc7da9414597b219ba93fbd28f2f82d9431bd83bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "220fedc94d5ee44855e5398248e53988c72a656899b9bcc40c0a2f66a02f5886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6638c1c4bf0c5b3b5af272f5094bd338d0f0fdeeb27aba3d92ac56ac98406ef0"
    sha256 cellar: :any,                 x86_64_linux:  "7bc80bba6b6d21d7362035dceb44edb7decd69c2bda8ed3bd93ce7363e4bfce1"
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