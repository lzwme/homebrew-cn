class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "97cb24a0d8b83220d1be45b51c8d6c9d763573e09a59e2ab64b6968e8078d45e"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8cc466067e3bdd8d04f35c3079b48b0dba082db62ab17e33a7649acc0be90b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3fb301062d10eac2558dd4b5f37e08af3b03c98196252524868b5a158329dc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8749dcc8005c1b3d4c224245b61fae706a877517dd7eb2a18f4bdd2d3ae2442"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab7794e0e465556950b5dcee323120eca499481b7aa9291b435b2157eb4e3b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42be51c297f5080d6801496af5af10eef0771dd18584df83097b47b77150262f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d816fdda4c874bbb3a58e79bb4560712fb6223642a6a5a057b4de055567c210d"
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