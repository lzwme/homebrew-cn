class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "8d6853c39818e033b3b2e2b12822681611555cbdf5b966e4010ed293a3d8740c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70bd09ce0c937beeb0b9dfad738645375a31a733cc04eb243cd4f793ba3131de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2d5d2f4da7a0747cd48b2aadd726f8c9e7c7c1d0daeb3382a41b1641aa91ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c69f72ca07aa606d5a3fe2bd02fa3cbf0ab03a2443386d3f9d86a0839460637e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c53113fc5477fedb22bef55b9b3c0670d7b497a313f555dd6ffc434e4dddb4a5"
    sha256 cellar: :any,                 arm64_linux:   "e0dccf4a750cd4b0229af147dd71a5c712b7b646524d75a2ba75ae10df973245"
    sha256 cellar: :any,                 x86_64_linux:  "f17d5cd63c76a58afa0b60ce95ebfbb75ace26edab181149eeed9c34aff5034f"
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