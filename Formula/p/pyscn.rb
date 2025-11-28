class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "43e0426ed9467298448c573c66385c7b14a29319b529f1dba834f3abd678d609"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4811a826755ef76fa92e1c6afcdc28e324816807d59a75a922a9be8bed28e131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840f2f4e2562bb356ec480b561076053f941298bac0b56c5f1c3d3fe1983fa0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631a942397f9875ae0b6b1ac2f2a199d3c012a8dc8f8255a5f10e532b62b394c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3235e0b59f43eb5a68962ac5c3f593f35e08f0867a4da7e8efd52d1a13059b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90a2e1d0af9f0b57047a643d766874a114edbe9136bb3f08c52b610781304388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57938264d46bc2339e39faf8f5e2258d5aea88378115a9f71937c4e5a435be26"
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