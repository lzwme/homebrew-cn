class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "4e35e9ad8c9ea357382eb55f55b38c31de99141b4aa9a37c5e33afeddee3ad25"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4ea2e686845e70b8c495f333566fd16787f9c1ed9afab880993cad28ed9f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7815677bf6d24cdc595597c82d57ad4dfb4ce4a7beebd7aa6812dca1f01f7852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918d9b015d5fc6c073af4cafdb36047cb714842b1dab3a88f70b6b12c8722053"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e346087905af6f974e8c34db58eaba0ce1b11eec2344f0a164c04ee2d40e25c"
    sha256 cellar: :any,                 arm64_linux:   "68dd71373f466b97fcf3ae3a9fd2bb5d3f5861d4b61973a0de28fc0c4dc260c9"
    sha256 cellar: :any,                 x86_64_linux:  "91684a6cee51a176ba6736c01b89297da0135ae8f68a5ecf26d1ddff0fc30c8a"
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