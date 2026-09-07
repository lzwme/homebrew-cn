class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "50a490e13b3fe6f1e9de7a83bd1ba1943b96e01469e538a9952a1aca81f1f76c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d7daf2f90e55adaa569bf9005ac1f94d7e83221e0408c5b157bd6aa8128dcd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad3df8a8f44f69268a5d9b680560fb526c282f6ae457c38ff4d20dcd6b497fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5c978fee8127eb5a9c2ceafeacd7098671b534a7f9fd5ccebca4e80309b48d"
    sha256 cellar: :any,                 arm64_linux:   "2adb2d4ef11717df9789f05e5ceaf360194e8f5b7ad25612cdb7e5ea225e0bfc"
    sha256 cellar: :any,                 x86_64_linux:  "939c0475f8a5771b4b601548a6336c5cd9a3e85080e9d9667799cd73014210e4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
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