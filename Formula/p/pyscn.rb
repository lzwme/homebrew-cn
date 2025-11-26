class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "26960521ba25c0428f3f000770a11cfc44bd6e80d4cc3e7325ea13c85a053d30"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5afce84cfdc08d1e22897a40d9f6314866173b8823b386a3459983a119ecf456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7f06d0808409b037313d41a42846377f2c3ca130b4e55e61c6f522ae26c11e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b70d9b3d7207b70123b2121b64589cbc781c4cdabd59fa699c25eb2178233ccd"
    sha256 cellar: :any_skip_relocation, sonoma:        "501aa73a354c5573c19f3f43261fe5afc1892e599a1bab6dc9fc1bc931c63d80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ed470e3210262d60502a639f55caa517f703764f964f8a3cbf767865a53b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63693909d38b3f722f7b0185b8191945a909e5be36338e82363e08645bbf447b"
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