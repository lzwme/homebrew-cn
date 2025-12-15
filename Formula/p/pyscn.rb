class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "01e38c18fe72d62cb1299976198e3bbf5f9000ddba6ad67e65841e80ddc4781b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b2fdb939496652c9e0f2858f0122b35c040946303c86d558eca89e7dd335f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a10998366d76da372c7e7881c7d40c20e7a79720c38bc3dd40c2e394083866b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82757b6abd548e7683070001f7ee95d01b96bc38b7000b1be5ad52cbc9657fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "da79580aee3f1c61ad2dd0d1e4c5b71bd0540cbdd8c218a7d76998963f2f36b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "962b99f719c4af088156aa2de165a0de696d5c692a2dd9b822c07778dc1934d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d203aa479d0d810db8d7e5982cec7f894725e4a3bee867d6c7be338f2b2c75"
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