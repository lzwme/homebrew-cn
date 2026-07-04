class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "0ce7931eac3367890d4eab3bd7bdcfa972cd8ea8777ebf8edde90226ff03ae9b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b5911270ebd469e6c38fe8e2321401067bbd706418abd66773dafde8c593a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c18a4fac76eb3071fda971960230264d643a81db366ea45a04136f4c7465016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900a3362165bb341e8e61f4413be567e32f3a8cff80f7793e9574e3d035f8054"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0ba1f0afd2d9ae347746567fb3b66237dc083a6f2a325f13bb4d25e65e7339"
    sha256 cellar: :any,                 arm64_linux:   "6aa7afea0f49ef6ab2f6278f543dc2892ce176af16cef939cb5e3fc886ccd423"
    sha256 cellar: :any,                 x86_64_linux:  "c0298b9e153ee6690a9f5ca3f8121a70218d23ec35b09131b06cc8c07452d105"
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