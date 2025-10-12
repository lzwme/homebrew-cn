class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "bf54f3579fbe1aa002fc6dfac3ec39ac4ff8ec728eec7b7eef25d01faf72080d"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9f7c73e757fd100bd2344a51a495cac5dd2f1df97ea958e3c6ff83547d0dd1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67af5b269cd0fa015aedc6b52699352a14cdb9097d5c4ff16674aa1200eb7cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d0d00df0f3f7156717c7dd76658f40abc2365212dc9ebeb91b9ab04a9ab1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2002365eb75734910730a5cf7b1b064235d3ab7047b5a5c6941fd29fe7f35565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1c3762f12d4403cbb57478d7b7ec695bfe05a91e58a4ddded92826c920def1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8fe46e2b2a46e889c30b1034e945d1764d4551118aeda16969f6e4ffa2954e6"
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
    assert_match "Health Score: 98/100 (Grade: A)", output
  end
end