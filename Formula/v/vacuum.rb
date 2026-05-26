class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "b2fda08bcd1d1d19a716c2e29a2cb0d85ddcfd45c0562c4ad5d4363090e143dc"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d54e2b113f5e329548783519107e0e48df1b180c733b52bb9e34f0bd30a468e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c21e108d2f8bd3fabff8d0bcee5b523d685fda3b8d73ba1313d695058225674e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b26458ed0c9ebfef3e98cc238870715fc12a2bc4a5b028ebcd78fb591e63fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "af103992712799c5e1f3090678893104a9835885b51cb3dbc2b933ea7a1d19de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "792297568c8975bde4dd1fc0d1201db396156bed6ae95f51d854645c90358168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3386c283d222901f5515ea50ea386b544cc3d40d0d01a9e6fc429da7c9016b7e"
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