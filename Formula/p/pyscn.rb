class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.4.tar.gz"
  sha256 "d5ca5bfd35713f4b6b3e30a07996aad71e62f66ba1b17a91a4792fb53acbbc5b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b12c72a797003f082c83f09e471c7482673a916de21ee946561f9eb13252e1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0342a8d621665e535a6888cf632abba208a13f5eebe546ace52fb6488cf6072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce2127d9ced52e961b52c5676a8e4f62186ba495c9cc07a70a00174bf2a0500"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f9b5a5a0eb4d629f4a119fbf5d1bb23ec0e740b2ce9af43bb7726860410d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8a0ce0e7d135d61f374f0a71800e18de303e384e69100c1014f5efa6b00c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd6e2cb2888fb04636b7e53c8621426c5022ff91a4264ec5989087a0364bdbc"
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