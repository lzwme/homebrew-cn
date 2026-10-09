class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "faec7f87b030469495038221189d25559aa70943edd5f78bb33d9e4a1620c595"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f024265added5b7a4e2990154330f6f674ecddf8a63cbb6f45b3055dc442937"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a8b637366617429ae6bd2b286ab8dc236581ae44265f60a106f36a245ab002b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "105b48d29b76ae4bfbfa82376cd0022ae5f7313f9265e769565af5cbe7145f97"
    sha256 cellar: :any,                 arm64_linux:       "0d478e45308be9bb65f88f65b253d632240ee63345493391b2806d9ffc016a18"
    sha256 cellar: :any,                 x86_64_linux:      "b057e6a3f18553bfdc8b533605fe3bf714c249938408a596281d55a6b813f30d"
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