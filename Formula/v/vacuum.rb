class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d8943b543c22e13ed4fa30c783757c23cea4c9890a8e14c0790aea1cc9144855"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a38a9c96b47835dba266c2fb30df0012fef37bc5062de66ed1f2cf59d5401eee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587b9bfa997f6fd6cc6fe23b02f41e13ecf0bfcbace8d849e4e2e110f6437700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60804d442f3d9bdc2cb97df1a1125905d78b5e3248b64307e3faf6c7caadcff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c439ae549f76d97204ee24977cb3679dfe5b1ac11711b9ac4cc1f0809ef9e3af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e90a38e4a58cfb8f3c2062d74465ffff913982b6815df56017730af828a7d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fce8d1fefe3cc9fb8f4e58393872e8553e0d7dcc777afb3314da913fe2cfa87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

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
  end
end