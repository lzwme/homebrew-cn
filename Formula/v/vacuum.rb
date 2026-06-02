class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "c58d490b422171094f7261a903aa6c0783b199e03e4854e335915e207158e8a7"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e4d4601d4e806ebd4a3e392b39f8ba6ff1f019f769d2d9230c456befb71f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72bf4b82c8c44b989f01ff399b88eed10fa7b85ce5cfd6fb0d99ee459a151b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f889eaec2c80b4b6f96c716406f860d0739f9f2d8c777bef401f1f5e84f82c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed7f330befaa1eee05d3db452c7e55ab9deb35134726bbdf9743d24194c7111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56dec056e80d3eba2bf066c6ab820ef5591ac443215681109824f468dc7b8cf2"
    sha256 cellar: :any,                 x86_64_linux:  "c64e93eebd3466a6d315bd25df8056b9b2b96002e76e5118e928381e219d9922"
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