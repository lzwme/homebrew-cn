class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.9.tar.gz"
  sha256 "86e9f2d62fe846bb380bfa65c89ec30f1e6c4c2143b940aacc2ab9434cca6830"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20591894c9e7d970cd9c7df4aa98b9a8f8014419bcecb09ee47f65c74a888cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a158483f863fd5b955fab1e0fbdba1d38ddbd98c3a771969638426767576cb78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c639a2bd1540958930be815ea788d147cffc6550f590539c8eace87a37bbc878"
    sha256 cellar: :any_skip_relocation, sonoma:        "4699ef72bf58d8384f2284d11dd16ecff63f27fd3a6005fe59f0e27b1ffa73c9"
    sha256 cellar: :any,                 arm64_linux:   "ac3c586f3f385cdae398b4795056cac85b99365821e4c4be4f9a993c609eced3"
    sha256 cellar: :any,                 x86_64_linux:  "bd84ec1eff6e94132403ab1cfe976f4483ba3dcdc7048e4094d91a7c6d292a8c"
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