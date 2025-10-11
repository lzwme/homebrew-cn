class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "984409a69f7385a9ec3738a460f3a23ff045503958b0c6ff36757d1bea599b07"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "238d2ce57d08ef1b809967dffb476a0ad0ea7c3a1f76d75a1f9379f8c9cefdc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a03d11215910ccc3e4578b366c218ccf1ad4c58f81b59806eeb420042b009d70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2557d6a8eacfc120064d0dbea11f3a03178ee109253871ec3fa60db27bde82"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34b407bc54258658439318b6976aa36395803364a68fa121b1cad0681798b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fd5a6cd7e60e7933a2b9ac5bf0797f19d8f6f7290a754f3d5d8c8dc9378488d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb34c0b715fe45b2b548612de4690c82bd5ffb2a999f074f4ddadd967b429418"
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