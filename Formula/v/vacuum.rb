class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://ghfast.top/https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "0eebdb7b96c534c14f21495f3f0c505341a34f88805c58c234c75c1dba9afa93"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6df4c50e385dc7318dbc0f48f25f6398e66ca7f5bc301b2d95d029316ae216b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f02503eec829b4e364cf3197d666d57e4e59562dcd3c12e82321a43dab5775e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0610abd9f1520a9dd369c8ba9a02e732a1d4116fdb70b396bafdf825b3021d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e02d3384c67ffd0c714027ebb7120507abdcbfd6300fea95cd3a4a653c120f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b72467332f17713c23a0cfc408d3e53a99430dddfd5e658d7c64d622a1a737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3bb58dec37858193a18e2516a12e451dd0c578a4273b29372b5c69bbe0e58d"
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