class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "b43d56c99a02fc1c67f8ce8455d5b6ca72ed3449442ab287ad6bd8e6523f8f97"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84c4c983b53032ec5f78957d20afa328e8323818e14048e39538cf293e0bce68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf9ac81c246465e7a298d9b09e87c3f04094a99ee62a8bd34ec03b9c077cb0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c42dcd911c55968694f3fd92e0677da077283e8877f9f6ac9f6d2bbb245fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "94754f7b6e1ae7e3b27ed60020626b91bf04e39444a548c98a879aee74a8d3fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495acdf2183baf825838c8eed2a2d61b77725883952c22f0607b817e8aafcfde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4bd2666020e217339a24dfd39d03691416d0a43937121dd0d1aa8cd5910f49"
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