class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "1accf7abf07206ceb6d80a87e602279b29f3fe02317e22e676ea88fa0c69a885"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea31653ecd28eb8656da5ef27ab0618262fd33b00f36a13d89254e50f85e710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3823b40483910e11d8de3481dfc95a87946d72903efd0882d4def2e1811aa148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a23547f88d0f8aa978395b19e6d067be497cdc55ca2dec37e0cb868881fc4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "319eb3568e2c108aeb7c6990d404c63146f2e0ed765fa2c5aeda6f48525757a8"
    sha256 cellar: :any,                 arm64_linux:   "4d9a2ac789867d11229404f9b049e136cae16d1af75a910cb185d0eb4c7e15e4"
    sha256 cellar: :any,                 x86_64_linux:  "380f7860562f4da4176444eee911d7fecd8cfff93e3015532b175fbd98880943"
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