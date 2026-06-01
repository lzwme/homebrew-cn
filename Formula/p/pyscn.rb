class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.6.tar.gz"
  sha256 "c397a6cf28b2fac7ab6b22a42cf99d47b11349d3b305b3d62f87b0e2a0cfe555"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91cd0c1e49e3897d126942a5f4d59eee44706d800693d7c7eed3727854caee96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1827d258edf7b3a34ff55188642d4edde0c524d2954fc5dc770e2aa8c88ada4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d38175b264593f58ef4af6defda02306b9b10e0515f811a430382ee4e15c35"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef0b2fe6e2ad62888fb524b48c8cb977b3a9e5964e085fb147cb1a92a2d519c"
    sha256 cellar: :any,                 arm64_linux:   "f557534a393ebb0e9b7b65ca67c895f461d27e4c8d71a482df688baa352aad89"
    sha256 cellar: :any,                 x86_64_linux:  "9d12964ae64aeced1ce955bf0f4d95a66f6f509369f705ea849aaf6a6b822985"
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