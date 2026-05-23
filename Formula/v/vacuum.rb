class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "f1efaeb9a97f88360bf673dc07f06bdb062ef670074d104089c0429a62081618"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3137b84fe4bc8816dc6977b554b61a1b87575c982a4ee17948489a25aad8911c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1070072082910c0b9fcaaef16e1b278fcb29b8bdc8191c8dcabea06951ca2cad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63ddacbf1066941fb7716571b619e3c5f128453e504d4049f580bad5587e98d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "854e66edf0ecfa666e8914aeb7a748ba32163efd8ef8d0f736e89b4a30952aa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed675669ca9801bf63e57e4c5c96c903c7d48e6273917794b64f304abefabb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680aee26dd4da3e25e9e6302abf43d8fbaac7b612d323f4bb4cac57bd34d0b3a"
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