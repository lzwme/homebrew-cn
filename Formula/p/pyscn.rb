class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "5b311c6646e64acb330beec554e4e47df2a4b4d0c696f40ba67ed3e5023642ab"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bfbbe5779c524c88544ca0d55b58ff40e67308e40fe896364a745af46ee09a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4211cbc3410ccb2b49f5bbdd31436de6fb21a6ffb996e2b077178dec6def4103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0417622ccd0111eaab085b757213ff06a26530ad31ad0039e8aa02d071199e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "892c053e4137a796be9a2b76be6a9c9f6f314ce7447a0f42a9eb818d3e3c0880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53c178211565d0c46085257abce9b445adc5cacb7ed7aebb917250f708a21c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9565c2dea5ac3b5813fbd4e2d3fd7dae11a6f4418d67d40010cb53ef928bb4b"
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