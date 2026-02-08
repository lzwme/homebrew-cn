class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "32b1f21a0f9b2935b5f00bc4c9403bac61fc30705d2dfae378bc742c609094ed"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6021586440844786db1f9bd4532bdc52d0167a7745d633e5fe8443c0397d3116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7de657ef1e6936554b04628aa0d6283de501478804a5fe40f9e0bc204c5686e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a33d7be49626529adb6275eabe28bf2bc72b39812a475f31cdb68890a4839edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5e2e892d7293cd0d00461d33c5fa8207e7387aac18b57231dae5243be562081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d374596e3039d8e9b9ac02bc2dccca9c609e8fbf65c226db4b7ccba999dae1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1752919cdb2815277692486a7d64012f369d620726e0b60252ced8e3bb1f12"
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