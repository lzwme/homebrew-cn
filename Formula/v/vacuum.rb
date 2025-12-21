class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "99b96080b373af0feaa8179121ac3f2862beadbb9537476255bc186469ae666a"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cafeb8844b9c5c0fa0a609ef6b3a7bef8d718daa45dc5bc00801a98a6ecda1bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059081b16a0ccdaac3d808887240320a30ec7257eb760e3e297ae5cd2f6a1e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e763cc20291effe4993d22ee14b0d5e5f1bd8f6244e935f95f223d076f3138"
    sha256 cellar: :any_skip_relocation, sonoma:        "a52fc5961fcd5b4db2fa60569c1a49027eeeea8bb2f59f0b70131d107d1143e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c2e28d63b6a47826f4a66eee9c05b498daa729ed7323cde53bb7411906e5a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58faea7b1cbed75ec8aba43b397bc410b076f3597f7798e6de22df19e3dbbe91"
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