class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "8c5cc506840bd0cb24e7cca0a34dd85e56f2dd791678aa9d654d43fb529bdb4f"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eaac812bb2d3e761d74cd16a4fc9e7617d0d59e3ec03443f8cab7c5aaeb65ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7963fadd1d94964a23f07c1b0c06ce45ead645996efdc3d03586250ffcc1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153f339dc5ff81da14d1c8f3fa03e7dc5d8a5a99634237c4291618ccb54e1021"
    sha256 cellar: :any_skip_relocation, sonoma:        "181b026bdb6821be449b19f4fb185e21070266fb0a8fda2f9986df97ea57b2d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97f77095a9149c8ac1a39a10eca4f1797b36e5b349fef04b82faa1564e8295b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcbece31a3c87dd2656d0d25bc258656a6b9d151f0f0c591b5e3f2110c638c4d"
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