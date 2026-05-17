class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "a08496ca140624b49ae6468f7e0978d8b24c7a6288d8e349c493074cb2ecda77"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "940d6cbe7660163fc1912124b0cda7b153baa90bf3716237255853dea59c6e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb159c1c678aa2325ebaf3ff2ef5ae2c8c8194845d9212f5c7d25b2ca809c502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b077f3f258684c719d19b7db513cb5a513d98542c5fd04b9e489b27887cb16"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6b62064db720381abd3943e1c1d03a1accdca558793734bf0c48e5600f4ac68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bce3d4bc212d60b96a504bfa93e840497ea980f3cf786abd33f9b1ff0ad22b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8a84832ff9263cfe018bf8911875b56ad2bb4f8caf9deb578a27c03812eb6a"
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