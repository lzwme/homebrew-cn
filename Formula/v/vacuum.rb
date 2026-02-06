class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.7.tar.gz"
  sha256 "bb3cad7146ef5bee00ff09b145205d721fd167c7eaaded9ac319f96bf577d43e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0043af17b148f4433bb4d680a937ad23cb8e6ab26a43ff8526179a1b2a150076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fda69cb80d98a3468dc35e5051b3cf85d5a91a354025dfe3f70ac0452c7ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c645faafbd5ad6fa48edaace5e99b5c734df19dae7275dbc40bf2c7aa3ea2eed"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ef780c8927f301c23853cf0b10e8d100915c6b8ed1b2468389b6f5bbd16348f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ab08ec83bfb237f5f84a66641baf07dfd049458fa96286bb6c92caa784258f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a79e693ec60c3dd7c561f8e2024eacdcfbb431cb6c45f8aea8bd21bd57fb11"
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