class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "af078951380bda0b459449b8ab098dca97c6c2b9f185b65632584b95ee03626b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08711872b7ce85035d8473d25020bbdb65c4360993b19117e4c83eb16548b327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f240d959b2b540f7e09f540aa15c6f913e5eab055246e64c9c650049268ab76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588f610d0126a88ddede60bd8775e6f555f8297a66c9c06a383df596a9846090"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4a790e60c814aba9e991e19e71942793933febe574cafe1dc571d6d725e882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ee78987d25ff8c9c90bb4d7ad9bead175a94a07e383b4cc3a231fd785e3891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a61aed87c10fee980ffd125e50b8605ffeb5e9cda9d3982343dcf48bb2914a1"
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