class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "59002094dab02eda9b4e6f0549c67d063852611fcec1922eceb0009c6e93befb"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91fcb45e47711e8c3bc2302cb141a4e1a49f5228ddab241ae4945f070dbe1122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04bbdfdbd3e0946374dcfceb5e1f633bfbbac4df094d4571a6ee5b316d57bb4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36608754be7c7cba58500d5fe2d476ff746dc0fc3eb0acb8fbf412ac667a037f"
    sha256 cellar: :any,                 arm64_linux:   "2cedba1e2956a6ee76e6bce862994c740104bb1ae3e10234dc02ee052f93d51a"
    sha256 cellar: :any,                 x86_64_linux:  "38d77e6bdb2c0b5278c9aa90d42f095fc6dec157936ba4f661954d3b6c75414f"
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