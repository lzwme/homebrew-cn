class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "75e708ef6a13bb6e2c84eb39120eacbc4744590a91586de79ae3f1a76f62e666"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b80f8f08bec5846e4e768054c30e1a02fb20c320e9082e2422e3d97996d2cb77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2caff965aeb5c332ccf645e51bacdb92c1309c9289c1259f14fc9eda1f57a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84afd704d452b8d33c614c32ded75c22d1e71a7b850d277c6657e1d951758f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6723319b9aa3862afc459647d49f42bce68e91d1083933709432bab0d7bf3f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a27aa808cf8a9e934561137e44b90d5b796ff4dd14eacfedae8f28eb672627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a960d7953206e28b19cdb6a0af7b2dbcad63a9acc945cd8c4ec0455d024dcbd"
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