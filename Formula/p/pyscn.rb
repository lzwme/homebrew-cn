class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "05a8a19995c9d0e557863bde674e1e3f29af4d3e23bedee2006ff5801e375a37"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c709ec7dce4ace649d1fd92a0e853e7ad75c1ed8791e9d9c7b5a9ec656dd48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737c865a4fbf44dbb0bebe0600b0126a7fc556dcf6fd1072e59a3c66e34727ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b1da48eb79543403ad1a6ef808195b5b01ac66853417c1b911f0bd88412660a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca52f883bd70c3d0da6869887f4448710c2ce6d674b2234a7b8368a40279be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30976a5ae9a4b93100c32088f7139d6ff84441d5256b99d464d54e55dd9e60a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b297714e0eecaeae4b3d480a50d59f7490ab77b64b0202a7ddaef93d66f53c"
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