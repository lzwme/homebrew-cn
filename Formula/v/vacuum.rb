class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "8478b09546c0f261089455b7c60d77682ba0f86359c149ca062f9590ae28c21d"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a133bba8e8e09c146baa2311f27825b5be95692e38a6d523451de92bc0e8a1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0babeb8bb151610bfbebdc1034f72102460fc14263f63220358b2d3ce9607f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c9f1fed81bef3f37bb44ce555f1502463f7606a03e3d8f01eb9336ed1cc462"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9afce92f890b6d0a21472fc37a2f39f9b5ce715f7796d841ab524e0afad46ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061fdfc888ea5e69d5b89544e598aab6b94c1df43b61fc0e0db458e5967fcc59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caea728aeb2d010eaec194af2f5dc93e166163013207411dc9f2833049f3cec7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
    end

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