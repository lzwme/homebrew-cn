class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "e44c3a5b9d7a0f9ca55487df54b6bef9858b25c6ad655f6e1eca13a244307645"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e0d8bc5f8d37022a71e41c634804e0929d225e56c490be1ee1b35d656bb21ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af82946cb652b65331c4ebc2dd257e93c0b2e66f13cf1b65cd2be5c81133ba13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99e1154e99a7ec22adfa966c5a42b50086c8a9c426404ac8b06dd9034e233e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "45a8e88f92279ab16c3a7b0d3f733879f802fe9363fb7ec2d9f077d3aa5c875c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558d717e7eb5da154fe0ee6bf14cb80240f515e7ec41f42ab51584556422c248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0398191d19512e77e4ccd7c8385bf2d89e669a7dece6b6a9dc8e24ed2f2994"
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