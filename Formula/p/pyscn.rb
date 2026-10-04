class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "a30d1a7990feefafd8938933155b3fdbeaad7b9ab379c77c7574cc5402ed446b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c9cc8f05ff66dff3844ef2f1f9d75e1847a46d628d0c161a9d1a2661b584e91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0031472c986b7654189452e11dd5d195e506758c1db7a517bcae59825cffc86e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99f2e8428d730fd3e8b96b99dd96d4b28c1c6974e0aa160b5d31410a544cf210"
    sha256 cellar: :any,                 arm64_linux:       "00dfc46c1e2e75130b4f8a3c603d8832f7d5ac20e5cce426e20249fe98149410"
    sha256 cellar: :any,                 x86_64_linux:      "b83403094dca5081ee5e0005621b539cf556e94fc05ccf14fdae8907f768b3e5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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