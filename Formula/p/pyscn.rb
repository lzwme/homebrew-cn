class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "d881aad40df434b1fc558df3e1b26ef6d76d44132a86362bb3f92b7ffbe74a03"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521c280b3c32ddb6da8d86c450d96cafe343ead640f6f15815a074271730ee8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a4b7808a9e9a6c1fd8a3a5c88a879fb2655b84e0945fc3bad1f48936d905f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7627acbde6e8be690f35a9aeeacf232e1a08dd5eb50407fea08060b12b9644c"
    sha256 cellar: :any_skip_relocation, sonoma:        "851d96d624a72d8361b29710d07a3c202b63b8ece841bc9e617086213212bf8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc35de209a9f24476e13b63dc1a3f3c6352dae342aeeb741bf5f56b3813a15e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7071844357763793c2dabaf2a106014d85057a19304fd2d7dbb1f375a7cbdf52"
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