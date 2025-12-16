class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "af078951380bda0b459449b8ab098dca97c6c2b9f185b65632584b95ee03626b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e0653134cf748bb7f4482e571f8aa4e6aa9af7160fb43edc426b9a7bf0266c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b92d1e1b239e76d7dcd1928dfd18e98655a936045f46dd485429706befbcfe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c59a2e8b95b384a8976beb073f4f0383332393eac40e0e0f3e460c9313eb516"
    sha256 cellar: :any_skip_relocation, sonoma:        "40bb5dcb51741f321a89cca3702294c3fcb1759cca12c77c39d8f70a8959b01b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8a54828050f49fc0444f778af56fb253e029923fa9abaef933bd15cef77ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e799ee9f508a43f71e89d3e4aa4e9f876c5670275bf8f335204ad0dc670a59"
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