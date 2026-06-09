class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "b7e16c86a047788886bdaf7ad6364347c68b2b088c7396ffed7d051c124cc723"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d37dea0f5daaab40ebffd797c673812775a92cd93465bbe9b223da37e2c04db5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "599f7c765d2e84d8554e866e44166b7875cb4f7aaf0143e2754994850b959ad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d29a4697f47a1a43873c41e11328b07ab54037ea5a76afe3c94b43744a87dcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5582b11fa548d06745b8947bba5b20228f1bb082db9dc0bd932c126945d0e9e5"
    sha256 cellar: :any,                 arm64_linux:   "63c24502b4145a73e2268d235d47a2491eb375fdaff6c58da49451005c6e603e"
    sha256 cellar: :any,                 x86_64_linux:  "a3add73f6e09e3823ba443be084c989a9522cfaea03545896f2590ec6e245d97"
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