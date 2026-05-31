class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.5.tar.gz"
  sha256 "b074d37ce5f0f7abb04515fb5b825027ac7aab92272bfe64820571c3039a19a5"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5ed59e19ad9abfa07e2348aaf2bb96bbb8c72c649f9785efc1ab986fe82efc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "433c88b0dff519f1c3bdb31b72de8797e2fd4de1da3d3b67df54dfd49c27c2d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02472e88940df92d5eb3deb0448356456112f6be89788b79342bb0fe27da0e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8766841ecf1bdc1724ba2da298947be59f52bb80b7be1c23a1c4fc45b307bee6"
    sha256 cellar: :any,                 arm64_linux:   "7f6af8574d0d3499732a8d94861357b5693711d431bbea01d683b54980d30ce6"
    sha256 cellar: :any,                 x86_64_linux:  "8d87b83060736452656842111a8390a9423955fe2ca0cfac4d228de9ed0f0583"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 97/100 (Grade: A)", output
  end
end