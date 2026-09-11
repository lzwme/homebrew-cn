class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.31.2.tar.gz"
  sha256 "132d012f88afe62e9200e7f5ef6994e5ac58fe6e4ca93e3b625ff35d963b630c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4354f8cb04a828a87cd16ce1cb94028822e99f95d73e332891f281e0b06d9875"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8899a6f768cd14a01e37ac39732806923a4cf85ff1df0ae413d41402990445e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac89e7eb95388fcab2ea3098df13993f01bb6b6e69f7360826bc1c420534051"
    sha256 cellar: :any,                 arm64_linux:   "085d12552ad2db168f189a823839bbde4c041d614b5d360d0676d09718e608ef"
    sha256 cellar: :any,                 x86_64_linux:  "23d33ee10b6cfccb42e586f62babb7fba7fe45cee2d489a7d886c682f89610fb"
  end

  depends_on "go" => :build

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