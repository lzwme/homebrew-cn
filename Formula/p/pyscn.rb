class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "192f094baa21e7e516a345194fb807c9f83d80b467bc1a99548dd049add8d467"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d121f6dcec049d4b93576cc8405efbfbbcb04e3f51f694f86bd54b914f071e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d54cd23e3d607482a718e3d7e264d9f86d43b32b0f516c42a47a5fc2fd8a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28824b1886672f565ffdbaf61be5f5e56014868e05a560d1491613bb31fa3a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd86cfa2eff4988d04a3cd547f1891e25944354485e1359542f977da8b4015e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c0ca339d98465762edf859ddcaa25f6f734f01343e4756d20a27aacee3eee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaaeea853f77e25658e06362f6731f36ee10f3b585d45fcf802977bcb22a8b90"
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