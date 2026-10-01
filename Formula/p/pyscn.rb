class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.32.2.tar.gz"
  sha256 "cddb8bb45b09bf5e9bc654dee36900904cb5228d6ae69c26740e0924ba81cb0e"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1617dac7b50c99dc62d4e37317b23c26c17cd6517fe920675251cac96276e64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b7225a36b439d3b749953406fbe94594b8fa59676381c8ea2988b74ab9003d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aaf8dfc341b81a220875987c6fdec77858f6627316c05ffbd2c761363ab9d27c"
    sha256 cellar: :any,                 arm64_linux:       "de811759d09d2f92ab006d2a4c6b03b3ae10d6593ebce3f19f82b642ccfb9dd0"
    sha256 cellar: :any,                 x86_64_linux:      "2b5131fe2a7273946cc30038e915c9c6c428fb29bc2c8fbc831d96c6a651fcc6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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