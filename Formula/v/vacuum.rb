class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.7.tar.gz"
  sha256 "567d75a7f46ae3b60ae6082652398ee22c0750c8acce582741c2aee987df24b6"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406302582a4e93578ab20e96b9e2baf17066cdb10700ea3020640a77d0888840"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6651931c0fbf14c8344e4c95e604071281856249e627e6ac30f53bf364a8074a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531d5657a20eb180d85a09578a6ff34f081d677ebedbbad7f821fb5873641229"
    sha256 cellar: :any_skip_relocation, sonoma:        "725a91af7c9d7a32a78ce970cf89842d6df338413dbdcd17e1076b88cab2929d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf986b2b8da2fd3f34cbb0d1001a827da7f1b1a1c9e0734a07fa192bddeca9e"
    sha256 cellar: :any,                 x86_64_linux:  "9ff805eaaf024762f004af4ca53b9db0fcf81933ccf0f6d33538c59bcf189be6"
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