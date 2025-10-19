class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "dbb5a4708eb9dcd850b979e73b311dda308e99ae110a5733e00776ccc4a5f3a6"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f0007d71c60215930f13fe918507c471155d12e2b90a99dc494ae17eb3d0e31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f8bb3d3cf8a73ea3da386218afc79f19d14518003544117fdd80e339932d911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "238d0f163d7544efe7bc78c4f62c28cc0f000057d9d66bd26f0c92df8add6743"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3525b3dedb14ec77768a26065dfd4cf7bdd7d9633ab1f0f8ef977005aecd866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a32adc3e343df8484849f2d6001985659621a28b4f889097777b768259feb351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d01837d3eb0fc03fd510fc4e84c7b479bdf31008b7a20cb8dc8fe3d3bccfec"
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
    assert_match "Health Score: 98/100 (Grade: A)", output
  end
end