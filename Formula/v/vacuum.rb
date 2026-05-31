class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "d7e8b4b46049a06bb3cb8489337d1681341cc2c2e00696adad74e2182e3ded41"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca0936b0971d58f7203e70d2e6b82ac09937c3b672d98b618a919112b8607d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30d178914b40cba7d0377881e6eaaab42e5c9b556f71cd68176b2b19ca073a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3de014df2f958836d44a0033b599bc5e55cc2c494d3065ec61e542adb62b4f6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbec7f8ed3e31c016f2aab0c731374d65f6b74f64da37811aaeb7a8a282aa452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00749faed548bb223d69b5095da74d3dc68848f8a4420f28050194b40aab1556"
    sha256 cellar: :any,                 x86_64_linux:  "0ced333c1a8f891f495f56f6af9b5d1beb9bac429129f05213f859557c95c05f"
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