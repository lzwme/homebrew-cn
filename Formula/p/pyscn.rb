class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "7a7aab6f2b190bdc640bd738cbcca88849e8da37dea61b69fa9413f08f41836d"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a087ab788bb31910a75803f1d544605d97e836a0f64830da5a844c6b451e38d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fce3ba6ee6d676bd649604129cf0a5922fd1ae9c633cec14531881a6c2a9d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e523ee5e01277cc904a400cd28e6e0540cab6518c0bf01f2d0699d83cc1c1e39"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06e36d4b582bb698c89df2e42d438275175c0baab7b1fff79d7efd5b500613a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e39edaf5da8c105ff62abb84ee8dd5243e974d29da4933750b97c4f2a0eb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e79e44d668e9b01dde3480588d34c5601c20de6a63118023826955dca2a8c2"
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