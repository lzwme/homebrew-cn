class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "aaaf0c0a5e08bb7b5d4f94af8f39a0717b7394daba2151a0e05f282498ed0f6e"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "afd248f049a14d3b47d5b42d5c669c7f1a25f97dd77781e2bd5f5f452fb5d556"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b00d49705acc7bdbd01991ca8c0f8494cda2c097d7fb5730864a592d55a2763c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df50915d6fb56c45c57b9c72452934966c586fb72e439a32cc926b64ef73aa8c"
    sha256 cellar: :any,                 arm64_linux:       "7b0e525ececf64497e64410ac2b70dfa520a4d0d12e0887ae9e649ffa0ea5645"
    sha256 cellar: :any,                 x86_64_linux:      "cb67706e13d0ca87e1f3079349ad38a37426824be9e4f3563020328b8fe7225e"
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