class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "e06e2b4ec3112d2b42d391dc2a8afd5baf3042951ce1ff399ba11faf94748a0c"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a93e739c3427e5c7f6aa110fd95cb9d27fa0caca4fac13284373a1de245a46ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860a0667935a34c8ffae2566a7c19972e53e22c01e419bd0889c85c22f126b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e160afe439602c50e89028e04160a706d3424e2feb6d11ef359b69e113a96074"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc0299b8aff628ab9771a4c08bdb0a104d9c226c7eb668cb14903b3ea4971f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66cbaa4d686d2747dcfde61609bc37cf37c04919f8ae4f39dcb8b1018af60abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8cfce0df1064f8f181aba7572d625b3c43f5f3167bb8041031db4085a953e9"
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