class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "a976e950082c9f32081696354253896b6e7ba44024d7311b6e8153cd97649ffb"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0471633c39f124c336df4ad28e921a3a29ecf62abd8d915c66bde4d3444e0c65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f21bb0b9a1180b1d65aaf9e5add810e15299f0115fea8230b6b63a71cd37144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d0eb87371698971089f555b72a6e44b678bacd0a2af2300bedd4d9af576d071"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d08ce03af9772a3808e586984abfbe313b8c8925a81613de19c64ba382fd85e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164d9a5ca82f8c94c8cdd4394e8dc0219fa162972131429db02855dd2f1d0d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e1339bb55e06dfdad9c14e8cfc1813dec3873841454ab551e683493e3547e9"
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

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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