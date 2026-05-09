class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "a0405690eb2012d0afc8b952ea5b2442b163280a6bb2c87be6fdb621411e7101"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "248e1f6cd2ba03110a80f4d6775a04cf28318599b3a92b4a531254678b653261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ef0e491796f9aa785970c967a4c484dac86a195da2c5481881fe3134413bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aeec2b3b53335b1dd504d36e692c8faf4e33ababb773faf6ba600b0d46f9edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc55e2a1ed5580f6e5e682b5c747e832993235003f2d6ef9f2e0657d63832500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b0c30b062a105fa2df94d393e190c5b5a87f66bbaadd30bb8a9654cd5a992f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd84442da97a86b230e1415fb45b73a172005017d0f4af1ee2eb7c9d9f1c7b93"
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