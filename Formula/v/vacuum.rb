class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "d9f0e100e88ecfb03ff5e4ecf83d0791ba3271f67675cfc57c80caf40465e247"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abc3d91ff6f780574cd18f9c0cda55447e0671b1a2975efe6661af7e914786c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d9944d1919fafd5ea868c2451202be5fdcc3b3351a1722ee2d5887c0a9de609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972e11cad48b1eb68b876c8ed4b4eae669f82d77f613190ce1383bbf91df067f"
    sha256 cellar: :any_skip_relocation, sonoma:        "700706ef52fd129b64e55ab6cc9eb68cf407e55f0fec9bd6afa151351727c07f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6814ff25669b8e25a8d7cf5de27fc15a00e4734c18c2808a42fb6bea4876db60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bfffb5be8e4fa5dcc9136de8828cb4b83017ea3905f57198dd424fef9615464"
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