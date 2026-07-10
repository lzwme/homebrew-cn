class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "ead5153d0f5f4cb121370ab9c7aaad7fe31d5f2a63d83b4cc4513cf3c92859ff"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16548be98d33543621c5223d8da9910a1c46e425fb03bc7794ee0aa82d9340a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0fc875c87bd3875bf2760ea5e8168b930a10220a862309bc8522eb456185d49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cccf48b87c5f1bf59171e399f88dea9857b1277eae4916ca6bf7d31b2e17e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad71ee29437f3aa54ce12f7222239a6a27d8ce801a94470247120a9ca8da94d"
    sha256 cellar: :any,                 arm64_linux:   "a504722df070203b173a6672c81d254d6c208d727dcb8ba8b961a12fd6ae7706"
    sha256 cellar: :any,                 x86_64_linux:  "015d259b77bcbb794d87f1cb37d1241dac26b76b85d3e2ec69ad2c90e1b20bbd"
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