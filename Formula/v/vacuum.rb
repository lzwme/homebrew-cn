class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "6aa11436806523a365c9dfe9c1d8548769e10aebd208783a12655d20ef9c2249"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dab986b0498c17c8db42cd1921bf01b2de027f652a1a38391eca1c588b120c75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4255d570fc4e50a94bd7863ac4c8ca82f8a0e3afb525b599bcd3c068444c6a63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d10c8d95ca787cb227324fa14ec943e569f4d3561c0748f2ec13572df6d1bc79"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d27a73def82569008ef15bd4427cddb4c4dbea669b3f2f40a85047f600fd80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dee604b068a745a0e27991fe97cad614d57db3769afade8763742b81ef88d31"
    sha256 cellar: :any,                 x86_64_linux:  "e3e8a1735b00cce8d18a0ed0a294991d8eed5f00fa7b25a23c7631606d85177b"
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