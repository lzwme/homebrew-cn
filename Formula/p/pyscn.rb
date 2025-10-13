class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a8a18b04278241f3e837c2eb0e618f9bfb51f86329d9cd3b3463151269f86ec6"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60797ba5380439e9eafa3b4110df0d738f19f21bebb73cb5b8aba5b9c1974cb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707a6ea42004956eeb4935a188ee43cbb3d5080684db8282c8b47e5dd918e81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85874bdb805808269956effd5d228db605d674ff168bb12e4d5610f65a21adf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f29e7361d466bcd00a27a00027d209d1f3c399169afcd8d392873d6ebf5aec5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bf99f577980ca05e2273bfd10518c470a4dd526b51f9a351d25a170af0a1495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fcf1170276e968c1f4817d10676599129694c3859e3e9180c45e6cf42bd7732"
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

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 98/100 (Grade: A)", output
  end
end