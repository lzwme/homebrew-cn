class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "4f4cd6f02084cce6e2945e7d09d4196442d015c81e33f18fe8ba4b178a5fa787"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da108c496a2d1d5eb806380891d1c08fe8b023cc90fd14bc2b6a2fbeffad3fef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72698609a7e8b135cdf4862d4a67aa61a69c6393bcbbf188c40e31a8aba0fff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa7ad76222a7b74a7e5126767e2f49fe761e42146710faec8d553aa60c8bab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "67596f0aeab7c7371de98df6673b1e66cd7dcc31f53c6ef9f582062006115ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11fc2dc4f1c284a34e818622d043410213d40a1c54c5efd178ac8676f9e7747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71b39400f3742c053400924f814533c4ec1ea89e779ac2e15a083c9e4c49f1d0"
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