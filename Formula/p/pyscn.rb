class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "19b792f03eaee3a2997bf4d8e52cfd37c5c47b1dd5654bbc92772bc443b57299"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3505451583a55adacd3d0196142ba4486db6768d747afd662e3dbb2efd1a0e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a063fcdcc34782a2a1e60d5eee8cd93e25d4242351e78071bfa871b3003c8887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3473eb310a34aa3d88a1de22e5ec78107fcb5af245dd81129141cec6b959a102"
    sha256 cellar: :any_skip_relocation, sonoma:        "94bedcec25649bdc4909c216b1ea1fa9f85a43e5d65bd358def21963229b3664"
    sha256 cellar: :any,                 arm64_linux:   "a8d70c1cb1c40d67dfc299597c93483979fbecbd7b84362590d16d1b000af97f"
    sha256 cellar: :any,                 x86_64_linux:  "bd8631da61f43803ebb2972a5711ab507183af17e57664488403994da830a031"
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