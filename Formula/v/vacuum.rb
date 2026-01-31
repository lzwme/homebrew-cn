class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "46738cb0ad25472b7dab64b3e1b2fb2fe0aa914ddf0e4123cc66f684c7cb99f8"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f59f79d8d265c1e5e156e824d0e4e29a4ddce3d5372c68a070482a0ebb96a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806f8659fe3878cb9e7bcd8ef1b685e090aa33ba919c5a2a5fa2e64520ae9ce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba10cdeb5601e626236d43679a11878ff0d6ddd379c18e4c57392d2c1a15d22"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ffdc751a9988860fb8d944d9ec6f9edca9486d6fc258fbeeeadd39b0c444b76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9d410e76563d99259d9071f5cc948f9ede556976bc63674401fbc4b1201fe99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fbfd7a172010a5ed8d62ecd3d3946439a0f338bd4d71c42e62e87548df24051"
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