class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "c30c4278ff6bec6a78b3f833bfb6d6047775f48f1af981c9ca440853661c9852"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2e4784a91c2c4e4c65868564553728e384c5efd3f292c73c521de6000b9103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c46dd518e1caac18be8bd25807c1a63564a8078a80cbe46f930d43d32432dca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01ff92d36fd166c8d920cfaaf4282ccda4530229bc3f08fb54427c8dc6f3fb9"
    sha256 cellar: :any,                 arm64_linux:   "33b0f8887a1a1705dd43f3711a7228af044663e76ec17482784efc2329bdea02"
    sha256 cellar: :any,                 x86_64_linux:  "1a5a0d0f8fbcc2101a38f266d94ee9335366640d93e688ccbe7b9baae9f23c81"
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