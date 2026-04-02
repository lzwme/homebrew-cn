class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "af61852fab26b9e47e0dc65a440f12661d496bf84fc7e9fe0ac313b7f1b8701c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea2867f2b7b823090b2f1e8eed92d2db9e0eb515a543a442eb3486c859be3a1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab772003360a77f72059f5ff9301c4ae0036a6bcb91e16975d63b35e6b5400d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06a8a0a8c5f33a34d3389fb1acce095e4ca58ba10d16f821eb34add116896b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "371ed23212288d2078cd5de417743059f41ab0bc54d21d8470ead8ab61d95c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d69b6dfe648ce8d1b95f3e01fbd146c447dc9d74d08be6e2ed8e44666a2e04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1055ed8ed1769146e6f31b63d5eff21271a1b2ac4c03f18b67725c34a6839e6c"
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