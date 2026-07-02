class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "399d79ac15f25a9a246258dcd0923e94c42542a42524eba4570e555a833bb2da"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c67b90153b9283d2e35321e6e5177df464e8a10e1b27e7ac893026e1e5129a99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9093b32fcc73679788ac845e5a3a9225ab9623c8152e314e838a54d2deeaefa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eea40f307dff40f7d50862895c3900ca5a2b9b0beca7363d0ad2934a415d7457"
    sha256 cellar: :any_skip_relocation, sonoma:        "498d44651d4038d61b98e8355d16ea42e3d255b5f372744697705b4a9680d0bd"
    sha256 cellar: :any,                 arm64_linux:   "d4ee9797e2bf6f1a19476b23fc631c9ebfdebea5ee8d3e890409b2090e2483dd"
    sha256 cellar: :any,                 x86_64_linux:  "6515f0bedd123c0d0302c90b08b842c98163816c203ac592d541799e1d145e21"
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