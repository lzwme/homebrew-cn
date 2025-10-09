class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "bc6c797d1ff2723c06ef5e4e54ae71b78585226620bf9d9481472aea112c578b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "498e35b1997b910c02c48f2ded0ff2971f05f3648d7f0bd4f5d84df26d3a83f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82fabdabfc51c717d398d741df7417ba21aaa4d84f0e23913eb1f26847a2ae8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "051fbed528a69c552aea59a89a7042b752461455908757b3358f87a32653df70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a49b4b64137b7e742b4bd8bbb3431f9917d2925a14062b38d62eab7b55630e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2951b563bcd21ef32d753d93ead92dfb453c8b43bb813501b1c2ffee6eb8c923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efcaf5eaf06ba7cc521eb715eb7d7b5db12d3741cac06f089bf2b12968a23db"
  end

  depends_on "go" => :build

  def install
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