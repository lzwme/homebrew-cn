class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "90d3b90caeea8f94ca3a69dbd8abb4ef20b3d8c8953191401a67251c5da2ee13"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7463c71e8cf56a03da830b99e334230efa8a049950a50a948584ac90ad80e3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "945b4599a9c3d44e0ad993f9ecc35813771d153853b0cb3624fd984e4cc4faab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405f666bebc2d2a627ef8362ef21911a88db150857b28f12cce06a3e9e9c2496"
    sha256 cellar: :any_skip_relocation, sonoma:        "43a2463f9877a876c1030eb3a9055b8547ffa4739802ad9c37abf6bdb6f67457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ded13ada388c21c24383608123c4c2d68952098e34ec907d4c45d37d9552f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea19ef701e41311f9cebfbddac8739542627cf7b09d89360bcebcf812161eead"
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