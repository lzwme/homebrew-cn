class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.8.tar.gz"
  sha256 "79f146867005eef966cdd22098b1abbe4c51e5e39d62058cde62f62505259137"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff7e0ed0c0057001faf02ed4d37998223cc0d6091c1f8dfa0b15ea702db8a8fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c70a9f75168562ae5e594b7d6a5585710928b61aa5cabb9c13b4d3db41b17ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b0cba7bb8efb872523e9d6b0d2af1f1c0526bdb972b4ed31e1ab4ec69a2bafc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a248863d37012632b767d763fb07881ddc0fc1c06ae15e7497bfdfb528adb59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a263882888bd46d358249b2b4643a620bdf5b84ef3a061bba09fafa551d625c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce8bf329643f2da4b29c2d06f8811827f3096d3940f7aa85aa7e15eea8901f49"
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