class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "01039f67c0eae78e953797d6cfaa193bcc0e1947cf83d8e0d136587692f36d49"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b3ab3fcab7e090b38fc2ef3deb483d227989b61e30ca29f75e859c70abfe253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64fca436c5278556e61e4c45aa2ade90bfd4ed50f0e0e775fd6a977416ce5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f792906e5987d711efec82080622b62c4e16c6592990f7fc77b77e76af0a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "739e7632a90464e3979c58eb8c726ef2f90a942bb2a0875d6d990624b4015e9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b6aa579cb02f321eadd2f3de33fa899e305ed2fac16919127b63f11be3cb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4468b707f7fdbc75e33ee15727a69357560875cb6dd92541e8e160a466da00c0"
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