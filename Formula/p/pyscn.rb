class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "0284affc5eb83a6077c1f926f5a5c43adda1bf8e7258bd94690c7d96de089c5a"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "042721cc18441a907156c07ebb0cd1a4e3084f780f95db12b093f8af77d01f02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea4a08ffe9052a1085d9e851ecda8b933b5d458b94451459c6f40551f098d3d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76acb809bba9939c5da4d6beae55ebdcb76019191c26516abcc4b61ce8078eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d59c4820cb44bc93b646125883a1038ecbca562ba96a78d7b0725d7f0bb2ca75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f06acf8e6a74d8981caaf818264a2a6dc384b97033dbe13a080c3414f4e7e45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6a4c3e725144f765a58a46e20cba648dbaa0ef61d1d301b52829792d0c086b"
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