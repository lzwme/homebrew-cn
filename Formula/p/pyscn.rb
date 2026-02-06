class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "c30ca1f9049ae17c28a1a5c001bf4db7e571f04d3ecc179f8ea833d730e1fa39"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef461cd68a5bb786a6407a90593ef91989762bf951718a523701bc5e109bc16a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263316fb979b0cacdacafc964603ce41abcd5507d25f06f71c33c1934a8432b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "164fa3a8cc34466cbbb55c07dcdc6e78bf4092a3aeeef014504ca0742d31482d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0b39122a156165b20bb61cbd5ca61ab83d0ce3bb3e4663ba39f6db6aa9ba5fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592446c8afb4ad52394d5e03e91ccf0a9b6d139c91511ee0ce079d256e0ca6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56642b9c69ad4213400aa1b34c86b407b58049f78bbe8cecf3bd591c79212fb8"
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