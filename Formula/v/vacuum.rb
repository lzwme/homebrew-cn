class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "c24971c7a42846ea60104c6566ce0f11c7795b5a599171a283d49e151fc435c5"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db737c9ea8423c5f8b926fbb8a54dc632e17d50546a1fca81ce17be3eea01bd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639d9130de38eb8de301e8890489ab85e24807ebc63e5c55632550cf81a8014d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25073c710811867f0a09a9aea91ad1c84bc1683fd01e4fed94956c9188dc779"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c7401d7023f9c4ceb150112c568bd6b8783376b3e97c08b6cad7da6eda3804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d78f81886d925900c3ccef9fa5dce74b16bba9c43f1cfb095d7af067b10b25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf989938b094bd972419d54352fb27dc7a21a8dfc3f95e9800103d566628ac5e"
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