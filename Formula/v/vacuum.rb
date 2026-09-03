class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "7f12ffef73aa8ba3397b4f2c979ca51cd705cbf9b680685803bf15da6d1dcf3b"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7798a207bd9c412d239600db73a03e00d9def6f1f09abe51a5c08fb3dafac709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d065731b8fa118ec5cbd739e54a079d7e4aab82e3286624b7c883406a307c4ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ca625e72e1f00e916009f559a4124d12b15aceefd962bfe8ce82336395f8a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95771d61f3c7c0227d34fcd8d6121aa377d85c12e1133f64e111c6c5369b01dc"
    sha256 cellar: :any,                 x86_64_linux:  "037a08a5f423f6c444bfa0d67994783c15176c02e4edf7cdc505b51098025418"
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