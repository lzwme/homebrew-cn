class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "90d3b90caeea8f94ca3a69dbd8abb4ef20b3d8c8953191401a67251c5da2ee13"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ee41e2c3b53b5e316bacca2c7751f1529ca022ce4d460807ef35da5d9239959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6781707ee72c0ddcf9390e9687bc627a4d023ae124af1fda0c147127f2649cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e311afa80265dd383ef8f56be1ec71ec5618a100d0562a8cef2ce23f13b53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "52e3912012ac40651e792ebe7e271e54e505c1d0650992b38153243b0daba3ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d09ae7ec10d614c4d952d4aa875bea552cc85588e49051a03331999b7c716f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42cf19025db718e35e3d7dedc23c58f19bdb97575b10bd76baf56e753ba02272"
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