class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "0cb449c7cf1a2eeea3ff21ca453c9d1fae66a2d6fdf2682b1720d1da837eca27"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f10acde938abd655a4fa0b66a3b649eebaa431b0cdc3abac20e3a2dc02b100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51bac3e795b8196e4aebe443359ce3e434ca34dde6086fb53b38f33eef8d897b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d64c96ff9a3ab8a0e43bd75dfda54c7f925395d710f6235985a9dfda99b9e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b06391f841c56b37df0baceab6f1417baa63a533ac5887ef57e359c2a4b9def4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f071e36fcd20cb06d73aa7eae507f7aef86113c51adec30ac05a91c4b0396704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f59b1acd1abb92c2b0043c2c69a5d35624b0ee7c4fe8480039ecd1adf11097"
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