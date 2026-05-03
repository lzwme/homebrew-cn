class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "06d4ae6b344c2413c6af582e2e27afba35f118bcb3a88bdce411cc760e8392be"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d21230e2570e6fd33da7511661f70bca0655dea72407e68894b254a680e37b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c9840b065fc8d9109f998c7a0e48b0e2653433d6a88713ad7f5b0c5d826879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "554c6fba1cd17f3862a2f79940b664360a801bc45047bbe54f5a2e79de66ec72"
    sha256 cellar: :any_skip_relocation, sonoma:        "7933f1d0632323490546d7ed72e4c1616e4970c8393ad7411e9359e407f99186"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a64caec56a5788d4ae09c28492138c289598d2a5026ffb974e670bce5c709c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c574382096eb3adb98dbe93455e402ff0c5e2a5d0c9f7eb88f4321e98fc6cda"
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