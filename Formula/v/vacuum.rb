class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "cbacc9c0f6791e466cbe1db2b4a06f30a79760291a32c2a7dcbd1f66ff6ac6da"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e50702ced3f9074056b5c504ea4091909b240e19f21f4acafefd885e2976a2cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8d8f86179fc9fe3f8bd81718b1dbc23948db83640712a561c780e02d9444f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f0254b364af2c2bdc3a4906dfb0e2f3d3d71e37169e95b31bfbbdef4332b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f73c18db6b9558a4bdadaa190e18cc90ee407c2fae924c57a397f8a03361d15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4295119096fac4fb08b8447cd2104af7fd29747c03a5a836b826fbb02926981"
    sha256 cellar: :any,                 x86_64_linux:  "8db7b764c86c84532a2d4fe6a00d92e9bfe84252d0d094b40e0cceb4a42b5f7e"
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