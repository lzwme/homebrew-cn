class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "ee6e09610d74fc1c44602d2e892ec22a129b03558dcf8be7da995863b470b26d"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c949dd56df45ac54d98563b3c7a35d4a628f14b5f2fea9e4da4dd687e70033"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a2cff11c49c92b16e7254477497d9585c541ea19bb78cf4ac9e3aec79e421a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9482b53189335f9d60ccb64e1eb66c5157d7fe9aebe57e6e923518c04a58bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe7941161cc9cf4c828d48c580c7f1d96f224edd1599f77edbb9eb1172e63b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7de0e1f0b137d244bc8282fab6ee9be40458a962984e09f34f575da787b9a9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ecdd8dadddf0652e4a26a0a0ba4c33744718da2ce7fe5f2bc85f3beaa30de99"
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