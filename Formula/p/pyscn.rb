class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "3d4bd79b55000868d535d5f3efd490e7958989ac5ec8cf8727feadd39bb8d067"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "490cd05adaec57151e65d742065e9016445cb3b82cfb7b7f855e4a1624b3485b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "def2641ff9ad3e30977b97f2b21454df1ac74856d8e1756d70236217e3580f12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1e75f779ec1fa32f7e92c625b207840b695fc0bfca4c944c3fb03737d4927ec"
    sha256 cellar: :any,                 arm64_linux:       "757e0186a3a8109076b3fe61b9f65affb3f3e1cc50e8b7ae6daee0d617ec25e7"
    sha256 cellar: :any,                 x86_64_linux:      "81a6dff042f764f0bbe897411a255f829b71725ac72763e0abe250d5d89180e4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
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