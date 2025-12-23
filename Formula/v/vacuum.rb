class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "a2714499ca30585847614842fd1987bf036a4277d25269f8820048e99c306018"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee0e767fdbc2991501153f218c4cf5328b62dc23d8dcdc075fba682cd926fe8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6bef6e8d27f3af48939be51025570b9a5be802e5488c992b277f30d3d919547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b455a579946d35b0ee540503fe103656907733bd8f1c27826dbc38d80efed05"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d34d8ea216bfa34d9bd19a92f30c256669561631e92a75216c739c6aa1cb91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe8307ddd27fef59382e8210808f33f7faecdbb3dd439fe221d518a69f52901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6782661bca75ed55423820f8907102fa4d27c9072e26c13cfc1c8ba6b63ff8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vacuum", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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