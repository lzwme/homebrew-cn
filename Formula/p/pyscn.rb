class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "476ff24f885c77eea523f2f53776c54b66bcf32285ea52a45c8e4e3b29d02e21"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db6f31a4e0dde5e8081cae2f19dec85a7b9152ee485e38754fbadf2e7afec258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0535bc8ddafe5773009224171b62765074d9e5d851921ec9385db55c3d9bd60a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7574d546bda1e90f453bd1297dd0e19ca0bd1a894874322e66af3f30c4551738"
    sha256 cellar: :any_skip_relocation, sonoma:        "c586138d7a0fef0d728364c96bc9f50400c4f5cc38e80802ea2bc8e57c69046e"
    sha256 cellar: :any,                 arm64_linux:   "1b50bc2bd104ca2ca63a9a96c46801f4db6d1a86666d97bd18dad445c041a30d"
    sha256 cellar: :any,                 x86_64_linux:  "d29116ac3abdccec14c4a0705441895d818c3eb79edc839806cdfa8cb545dc3c"
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