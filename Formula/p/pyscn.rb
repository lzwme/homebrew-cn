class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "ce33b4769804e56e567ee7fa4a8a87f96a87daa234fa800949f593d0c6761634"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f527627e31f3712bf9a58658390e8d77fd01d2273437cbcc8f1a8971f4cfcd8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e1d170ee2859f77bdebb899dfae2f9ae59fad07d8ba30672598630ff433d49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "029d00d77966e74f958345d2769dbbc38403beda5864bce6322a3e6283bc4269"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2fbdc729f91d9aa2224bba3bdcea29fa5cd1b6dc331721b0db7ade3f806b57"
    sha256 cellar: :any,                 arm64_linux:   "8f79bdcb309d4192b823230d9a508055ee7c40ce02738dfddafefccbb7d2f6db"
    sha256 cellar: :any,                 x86_64_linux:  "4d615138e894cbae29d56a345f19f40ea530834663864d2b237afc8eae365ecf"
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