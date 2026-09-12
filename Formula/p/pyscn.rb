class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "5046c13392fa66f70b6a840c4060303217c38cda2abd3701ff7b5fe3fbf39a13"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57804750e91ab5337e40517c1ee24d645034d30768687b3548e5f96ca01d218c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a49896d8a9ab95fc5b70e5de919829951b4023b3f4ce93e917d614da465f6294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed1baa88234d69a66d116e11ce4a1aa87975195554ffe6477c1194847bf417f8"
    sha256 cellar: :any,                 arm64_linux:       "cdfabd5c11849bcfdd51a6e4fd4671b577ee330925e78e2909820b00d48bc748"
    sha256 cellar: :any,                 x86_64_linux:      "1302889f964bb2b13360e43b51f584ee7916d224dc4bae5474f44a50ff560df4"
  end

  depends_on "go" => :build

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