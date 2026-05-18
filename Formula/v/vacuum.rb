class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "8a1ad2cba4c49f262025a1d30faab2c7cd104ee35ccb41dabf1d81895e1c8611"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0211c4f5658a912a0b79cbf8ac0cfa1c71c72a7a30c4e96dc4e27819d74f71b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ac75e754dbe137bbc97ebfa390751ada14ffbb574263a12d6f1b2a2285a95a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d34a161cfd2120668f3ca554beba1fab60057bdf34b9839ab2d3ee331ed7ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2725c3fd14e8c944f19fb6b0d3cd072608d8bbd28e3e69bf14c95bf92ee464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23abd014c705e588e535e5044e1cebb87970f060eb2035b8aa55bd935ea62754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0d621659f5a6e07057c682d591a4e16617c8889e0e4155392260a17eaf719d"
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