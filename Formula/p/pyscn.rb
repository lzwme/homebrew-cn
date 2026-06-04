class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.8.tar.gz"
  sha256 "768ddd080e4e2a0b1838f794c58f73da635de3922bf12dc92759fbf850fecd98"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c816be5c013ab7fb89bb5af84d39acd08255d83aaecf843469283fa0a5a300da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4776b9a048c4395d15798c3b7fe147aa508ee393addf4a300bba13afcc6b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f6cba10c0c896148a1e23746896b8d06f4eb19ee3ea5c0190e768d83344313"
    sha256 cellar: :any_skip_relocation, sonoma:        "af4b3ba915b750069a304c3ef223ff8a0b381595519fa706053deb5ae1b87d24"
    sha256 cellar: :any,                 arm64_linux:   "45af8ed4383e8cb9544edc1168121f3e0a44326095b6ad19bb6fc2d64f94918e"
    sha256 cellar: :any,                 x86_64_linux:  "b22d3040450618c8e11888ba6854f57878c1ad08b42ce531f7a7d6a4654ebd87"
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