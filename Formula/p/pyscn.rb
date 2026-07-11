class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "1fae7ea8965112d23da0ba07789ea84bf2e999b7f5d29d2208cdf2e3ddf46c76"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1d982971578d378256244fdfa782dd07e01bb262df22f777c29a8d0cb32d271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ef467d7a349d9c0238a7d047a59663bd3a922c5b508acd7d2673562518d1eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ecfda67c48ee03608a8ecdbef8a6cbb7999f47753e4de23971d3fb63a30098"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca996d84b65cf476b955bdc17adbb3b0d40738b96800ce54c7c26f35ea6d903d"
    sha256 cellar: :any,                 arm64_linux:   "df36e97c7f434acc0b0f6332a085c13a88336e3bd87551b42a8f27e5fb348d06"
    sha256 cellar: :any,                 x86_64_linux:  "8146ddde8c96ea327153c2ede0b3fc67b9959ecba458552fcf17f14cbf38958d"
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