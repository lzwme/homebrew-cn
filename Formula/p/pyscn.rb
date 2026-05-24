class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "b918ee75e1b1b536920d40a65674d04030fa0bac205a51a02125f55f183cb928"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ee2df187698a66e7a42c3989d5223d6be18d8c545e03f180567af7527c5295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b891bb2ac8c6ebc5f6e214a7c8bc412630520174c8af60defeaa48fb833a5c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d83e9d0438824e42860055e06274fec315d9fee619b4529a9e6f69b3256526"
    sha256 cellar: :any_skip_relocation, sonoma:        "1778dbc5201623ff938394e88b81e760664e536931da47b5881436e22594d864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bcf14dfcd664bea60707d1dc37a9edcafcb1745d778df98f5719e9585b92222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b135183db216566c3ffcff1b59178d2ec4aefa588e43e0b0daf0ba71d90c098"
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