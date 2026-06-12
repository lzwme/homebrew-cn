class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "82458a02fe201c583d5aba55b285fc8b2a99002b24e607bcb60fe1781cc1d7f0"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd741dede8d32b7a1d2355193b53a5c79b594732fe5d05676006a04b5f1d48d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673a31f94f92c29a630a84d813e1f08a4b159b87811b032d4baf782ccb34a8dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56348940b0a1db6720b7c3faa599e5b36e4049fda23458b076436d590f528dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5b39093efe8559b6209c224b318cce66d451cd6b7fe7f07e89f5234464ba4b"
    sha256 cellar: :any,                 arm64_linux:   "bb8f2b1c40934341109732d962967d4c3a235cd19d459a3bfbda744e9114a9eb"
    sha256 cellar: :any,                 x86_64_linux:  "b495134258e4bc2babd2bf79577dee827424fad9b1b84e8ac979c46acabc9705"
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