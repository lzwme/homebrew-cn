class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "926ff62e1ac7403f74daac2f98b426fe25cb64bada5ac930bd18ded815e3994c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6dc4bcde9e3d1a7096cc0c49a5a8491a4e9a67d6d51bd7d8317a97a00a0e84d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3268870666777d118e16f8a20c40fa543b79539fe62078af57be7d34fc698149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "331c8d641446545b837b3bcdb4b22efb225055da8804cb2a491ace350cb104fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9973657f4f6bd484c66ccc80ec20ed4c998982792e9637eccbac7b04e7263517"
    sha256 cellar: :any,                 arm64_linux:   "7be9621e3bf7412ccd55038fb7f3db1d69e61c6dbab61b2ea88ee42b6fe662db"
    sha256 cellar: :any,                 x86_64_linux:  "520f877e7108378506ffcd60b52b0bebfea725bb9ede17fda1b4947ae8dc2a02"
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